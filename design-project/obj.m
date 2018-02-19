close all;
clear;

if 0 % for testing
    load('rt_spiral_03.mat');
    n = 128;
else
    % get image
    n = 128;
    im0 = phantom('Modified Shepp-Logan',n);
    IM0 = fftshift(fft2(fftshift(im0)));

    % Get k
    Ns = 1e4;
%     a = 20; b = 60; d = 0; % lissajou parameters
%     t = linspace(0,2*pi,Ns);
%     k = (sin(a*t) + 1j*sin(b*t + d*pi))/2; % trajectory, -.5 -> .5

    turns = 80;
    x = linspace(-pi*turns,pi*turns,Ns);
    r = linspace(0,1,Ns);
    X = sin(x).*r;  Y = cos(x).*r;
    k = (X + 1j*Y)/2;

    % get d
    kx = (n/2+1) + n*real(k);
    ky = (n/2+1) + n*imag(k);
    d = interp2(IM0,kx,ky,'spline');

%     % show me what it looks like
%     imshow(log(abs(IM0)),[]);
%     hold on; plot(kx,ky,'.');
%     plot(kx(isnan(d)),ky(isnan(d)),'.r');

    % get w
    w = voronoidens(k);
    [ ~,idx ] = max(w);
    w0 = mean(w(~isnan(w))); % might use a better number here? Another param?
    w(isnan(w)) = w0;
end

% function [ f ] = obj(x)

    % Now set reconstruction parameters
    o = 2; % fixed oversampling factor
    W = 5;
    kw = [ W,1e-6 ];
    
    recon = grid1(d,k,w,n,o,kw);

    figure(2);
    imshow(abs(recon(end/4:3*end/4,end/4:3*end/4)),[]);
end