function [ f ] = obj(x)
    % fix n small so it's reasonable computation time
    n = 128; % image is nxn

    % find Ns samples along trajectory
    Ns = x(1);
    
    % Grab the image - spatial and frequency domain
    [ im0,IM0 ] = shepp(n);
    
    % let's generate a spiral trajectory
    turns = x(2); % how many spirals
    k = traj(turns,Ns);

    % grab complex k-space data, d
    d = sampleIm(k,n,IM0);
    
    % we need weighting function density compensation
    w0 = x(3); % this can be a param
    w = densityComp(k,w0);
    
    % reconstruction kernel parameters
    W = x(4); % this can be a param
    tol = x(5); % this determines kernel oversampling factor
    kw = [ W,tol ];
    
    % Perform the reconstruction
    o = x(6); % oversampling factor
    recon = grid1(d,k,w,n,o,kw);
    
    % trim down to size
%     recon = recon(floor(end/4):floor(3*end/4)-1,floor(end/4):floor(3*end/4)-1);
    
    try
        if ~isequal(size(recon),[ n n ])
            recon = recon( (floor(end/2)-n/2):(floor(end/2)+n/2)-1,(floor(end/2)-n/2):(floor(end/2)+n/2)-1);
        end
    catch
        fprintf('Index problems...\n');
    end
        
    if ~isequal(size(recon),[n n])
        fprintf('Uh oh...\n');
    end
    
    % Now see how well we did...
    % f = norm(im0 - abs(recon))^2;
%     method = 'prewitt';
    method = 'canny';
%     method = 'roberts';
%     method = 'sobel';
%     method = 'approxcanny';
    f = norm(edge(im0.',method) - edge(abs(recon),method))^2 + norm(im0.' - abs(recon))^2;
    
    %imshow(abs(recon),[]);
    if isempty(findobj('type','figure'))
        subplot(2,2,1);
        imshow(edge(im0.',method),[]);
        
        subplot(2,2,2);
        imshow(im0.',[]);
    end
    subplot(2,2,3);
    imshow(edge(abs(recon),method),[]);
    title(sprintf('f = %f',f));
    
    subplot(2,2,4);
    imshow(abs(recon),[]);
    drawnow;
    
    % disp(x);
end

function [ im0,IM0 ] = shepp(n)
    im0 = phantom('Modified Shepp-Logan',n);
    IM0 = fftshift(fft2(fftshift(im0)));
end

function [ k ] = traj(turns,Ns)
    t = linspace(-pi*turns,pi*turns,Ns);
    r = linspace(0,1,Ns);
    KX = sin(t).*r;
    KY = cos(t).*r;
    k = (KX + 1j*KY)/2; % bound k from -.5 to .5
end

function [ d ] = sampleIm(k,n,IM0)
    kx = (n/2 + 1) + n*real(k);
    ky = (n/2 + 1) + n*imag(k);
    d = interp2(IM0,kx,ky,'spline'); % simulate data collection
end

function  [ w ] = densityComp(k,w0)
    w = voronoidens(k);
%     [ ~,idx ] = max(w);
%     w0 = mean(w(~isnan(w)));
%     w0 = w(idx - offset); % choose a neighbor
    w(isnan(w)) = w0;
end