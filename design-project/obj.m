
% function [ f ] = obj(x)
    % Grab a shepp-logan phantom with enhanced contrasst
    n = 128; % use a smaller n for quicker computation
    im0 = phantom('Modified Shepp-Logan',n);
    IM0 = fft2(im0);
    
    % sample this image using given test parameters
    Ns = 1e4; % fixed number of sample points
    a = 10*5; b = 45*6; d = 0; % lissajou parameters
    t = linspace(0,2*pi,Ns);
    k = (sin(a*t) + 1j*sin(b*t + d*pi))/2; % trajectory, -.5 -> .5
    
    kx = (n-1)*(real(k) + .5) + 1;
    ky = (n-1)*(imag(k) + .5) + 1;
    d = improfile(IM0,kx,ky,Ns);
    
    imshow(log(abs(IM0)),[]);
    hold on; plot(kx,ky,'.');
    plot(kx(isnan(d)),ky(isnan(d)),'.r');
    
    % Now set reconstruction parameters
    o = 2; % fixed oversampling factor
    err = 1e-3; % fixed error factor

    w = voronoidens(k);
    [ ~,idx ] = max(w);
    w0 = w(idx-2);
    w(w > w0) = w0;
    w(isnan(w)) = w0;

    W = 5;
    kw = [ W,err ];
    
    recon = grid1(d,k,w,n,o,kw);

    figure(2);
    imshow(abs(recon),[]);
% end












