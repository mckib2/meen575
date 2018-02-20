function [ f ] = obj(x)
    tic

    % fix n small so it's reasonable computation time
    n = 128; % image is nxn

    % find Ns samples along trajectory
    Ns = 1536; %1e4;
    
    % Grab the image - spatial and frequency domain
    [ im0,IM0 ] = shepp(n);
    
    % let's generate a spiral trajectory
    turns = x(1); % how many spirals
    k = traj(turns,Ns);

%     load('rt_spiral_03.mat');
    
    % grab complex k-space data, d
    d = sampleIm(k,n,IM0);
    
    % we need weighting function density compensation
    w0 = x(2); % this can be a param
    w = densityComp(k,w0);
    
    % reconstruction kernel parameters
    W = x(3); % this can be a param
    tol = x(4); % this determines kernel oversampling factor
    
    if tol < 0
        fprintf('something has gone terribly wrong...\n');
        tol = eps; %abs(tol);
    end
    
    kw = [ W,tol ];
    
    % Perform the reconstruction
    o = x(5); % oversampling factor
    recon = grid1(d,k,w,n,o,kw);
    
    % trim down to size
%     recon = recon(floor(end/4):floor(3*end/4)-1,floor(end/4):floor(3*end/4)-1);
    
    try
        if ~isequal(size(recon),[ n n ])
            recon = recon( (ceil(end/2)-n/2):(ceil(end/2)+n/2)-1,(ceil(end/2)-n/2):(ceil(end/2)+n/2)-1);
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
    %
    %f = norm(edge(im0.',method) - edge(abs(recon),method))^2 + 2*norm(im0.' - abs(recon) )^2;
    f = -(corr2(im0.',abs(recon)) + 1)/2 + norm(edge(im0.',method) - edge(abs(recon),method))^2/300;
    
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
    toc
end

function [ im0,IM0 ] = shepp(n)
    im0 = phantom('Modified Shepp-Logan',2*n);
    IM0 = fftshift(fft2(fftshift(im0)));
end

function [ k ] = traj(turns,Ns)
    interleaves = turns;
    turns = 9; 
%     interleaves = 6;
    t = linspace(-pi*turns,pi*turns,Ns);
    r = linspace(0,.5,Ns);
    for ii = 1:interleaves
        KX = sin(t + 2*ii/interleaves*pi).*r + ii*eps;
        KY = cos(t + 2*ii/interleaves*pi).*r + ii*eps;
        k(:,ii) = (KX + 1j*KY);
    end
end

function [ d ] = sampleIm(k,n,IM0)
    n = 2*n;
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