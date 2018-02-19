function [ m ] = grid1(d,k,w,n,o,kw)

% function m = grid1(d,k,n)
%     d -- k-space data
%     k -- k-trajectory, scaled -0.5 to 0.5
%     w -- preweighting function
%     n -- image size
%     o -- oversampling factor
%    kw -- kaiser bessel kernel parameters, [ W,err ]

% convert to single column
d = d(:);
k = k(:);

if ~isempty(w)
    w = w(:);
else
    w = ones(size(d));
end

if isempty(o)
    o = 1;
end

% Oversampling adjustment
n = round(n*o);

% cconvert k-space samples to matrix indices
nx = (n/2+1) + n*real(k);
ny = (n/2+1) + n*imag(k);

% zero out output array
try
    m = zeros(n,n);
catch
    fprintf('n might be too large...\n');
end

% Use the kaiser-bessel kernel
if ~isempty(kw)
    err = kw(2);
    kw = kw(1);

    kosf = 0.91/(o*err);
    beta = pi*sqrt(kw^2*(o-.5)^2-.8);
    hwidth = o*kw/2;

    try
        ps = (0:kosf*hwidth)/(kosf*hwidth);
    catch
        fprintf('problems with kosf\n');
    end
    kernel = besseli(0,beta*sqrt(1-ps.*ps));
    try
        kernel = kernel/kernel(1);
    catch
        fprintf('kernel has no samples?\n');
    end
    kernel(end) = 0;

    for lx = -hwidth:hwidth
        for ly = -hwidth:hwidth

            nxt = round(nx + lx);
            nyt = round(ny + ly);

            kkx = min(round(kosf*abs(nx-nxt)+1),floor(kosf*hwidth)+1);
            kwx = kernel(kkx);
            kky = min(round(kosf*abs(ny-nyt)+1),floor(kosf*hwidth)+1);
            kwy = kernel(kky);

            nxt = max(nxt,1); nxt = min(nxt,n);
            nyt = max(nyt,1); nyt = min(nyt,n);

            m = m + sparse(nxt,nyt,d.*kwx'.*kwy'.*w,n,n);
        end
    end
else
    % loop over samples in kernel
    for lx = -o:o
      for ly = -o:o

        % find nearest samples
        nxt = round(nx+lx);
        nyt = round(ny+ly);

        % compute weighting for triangular kernel
        kwx = max(1-abs(nx-nxt),0);
        kwy = max(1-abs(ny-nyt),0);


        % map samples outside the matrix to the edges
        nxt = max(nxt,1); nxt = min(nxt,n);
        nyt = max(nyt,1); nyt = min(nyt,n);

        % use sparse matrix to turn k-space trajectory into 2D matrix
        m = m + sparse(nxt,nyt,d.*kwx.*kwy.*w,n,n);
      end
    end
end

% zero out edge samples, since these may be due to samples outside
% the matrix
m(:,1) = 0; m(:,n) = 0;
m(1,:) = 0; m(n,:) = 0;

if ~isempty(kw)
    x = (-n/2:n/2-1)/(n/o);
    argsq = sqrt(kw^2*pi^2*x.^2-beta^2);
    dapx = sin(argsq)./argsq;
    dapx = dapx./dapx(floor(n/2));
    dap = dapx'*dapx;

    m = ifftshift(ifft2(m))./dap;
end
