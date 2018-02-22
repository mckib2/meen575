close all;
clear;

interleaves = 8:11;
w = linspace(1e-6,.005,30);

for nn = 1:numel(interleaves)
    for mm = 1:numel(w)
        tic
        f(nn,mm) = obj([ interleaves(nn) w(mm), 2, 3.1899e-4, 2.53 ]);
        toc
    end
end

%%
figure;
contour(w,interleaves,f);
title('f(w_0,interleaves)')
xlabel('w_0');
ylabel('Interleaves');

%%
% TR = 3e-3*6;
%     
%     kosf = 0.91/(x(5)*x(4));
%     kwidth = x(5)*x(3)/2;
%     
%     c = [];
%     c(1) = 2 - 1/(TR*x(1));
%     c(2) = 1 - kosf*kwidth;
%     c(3) = kosf*kwidth - 1e4;

oversamp = linspace(1,4,10);
h = linspace(0.5,25,10);
f = [];
for nn = 1:numel(h)
    for mm = 1:numel(oversamp)
        tic
        f(nn,mm) = obj([ 9 1.21827329356537e-05, h(nn), 3.1899e-4, oversamp(mm) ]);
        toc
    end
end

%%
figure(1);
[ C,H ] = contour(oversamp,h,f);
clabel(C,H);

hold on;

TR = 3e-3*6;     
kosf = 0.91./(2.53*3.1899e-4);
kwidth = oversamp.'*h/2;

[ C,H ] = contour(oversamp,h,kwidth', [ 1/kosf 1/kosf ],'r');
clabel(C,H);
[ C,H ] = contour(oversamp,h,kwidth', [ 1e4./kosf 1e4./kosf ],'r');
clabel(C,H);
% bound oversampling
plot( [ 3 3 ], [ 1 25 ],'g--');

% plot the optimum
plot(2,2.531,'rp');

title('Feasible Region');
xlabel('oversampling factor');
ylabel('Kernel width');