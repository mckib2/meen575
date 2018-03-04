%% Homework 5 - Simulated Annealing
% Nicholas McKibben
% MEEn 575
% 2018-03-03

clear;
close all;

% Objective
f = @(x1,x2) 2 + .2*x1^2 + .2*x2^2 - cos(pi*x1) - cos(pi*x2);

% Set the seed for reproducability
rng('default');

%% Params
a = -5; b = 5;
numx0 = 3;
x0s = (b - a)*rand(numx0,2) + a;
Ps = .9;
Pf = eps;
N = 250;

%% Simulate the Annealing...
xopts = zeros(numx0,2);
fopts = zeros(numx0,1);
hs = cell(size(fopts));
nobjs = fopts;
for ii = 1:numx0
    x0 = x0s(ii,:);
    [ xopts(ii,:),fopts(ii),hs{ii},nobjs(ii) ] = anneal(f,x0,Ps,Pf,N);
end

disp(table(xopts,fopts,nobjs));

%% Some Plots
figure(1);
x = linspace(a,b,1000);
[ X1,X2 ] = meshgrid(x,x);
contour(X1,X2,f(X1,X2));
hold on;

for ii = 1:numx0
    h = hs{ii};
    xopt = xopts(ii,:);
    fopt = fopts(ii);
    
    hx = h.x;
    hf = h.f;

    plot(hx(:,1),hx(:,2),'.-');
end

legend('f(x)','x0_1','x0_2','x0_3');