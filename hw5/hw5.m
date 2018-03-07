%% Homework 5 - Simulated Annealing
% Nicholas McKibben
% MEEn 575
% 2018-03-03

clear;
close all;

% Objective
f = @(x1,x2) 2 + .2*x1.^2 + .2*x2.^2 - cos(pi*x1) - cos(pi*x2);

% Set the seed for reproducability
rng('default');

%% Params
a = -5; b = 5;
numx0 = 20;
x0s = (b - a)*rand(numx0,2) + a;
Ps = .3;
Pf = eps;
N = 40;
n = 3;
sigma = 2;
show_paths = 1:10; % show paths for these x0s

%% Simulate the Annealing...
xopts = zeros(numx0,2);
fopts = zeros(numx0,1);
hs = cell(size(fopts));
nobjs = fopts;
for ii = 1:numx0
    x0 = x0s(ii,:);
    [ xopts(ii,:),fopts(ii),hs{ii},nobjs(ii) ] = anneal(f,x0,Ps,Pf,N,n,sigma);
    
    % Make sure to choose the best one we remember
    [ val,idx ] = min(hs{ii}.f);
    if val < fopts(ii)
        %fprintf('I chose the wrong one! %f -> %f\n',fopts(ii),val);
        xopts(ii,:) = hs{ii}.x(idx,:);
        fopts(ii) = val;
    end
end
dist_from_opt = sqrt(sum((xopts - [ 0 0 ]).^2,2));

disp(table(x0s,xopts,fopts,nobjs,dist_from_opt));

%% Some Plots
% Get bounds of contour plot
x1mx = b; x1mn = a; x2mx = b; x2mn = a;
for ii = 1:numel(hs)
    h = hs{ii};
    if min(h.x(:,1)) < x1mn
        x1mn = min(h.x(:,1));
    end
    if max(h.x(:,1)) > x1mx
        x1mx = max(h.x(:,1));
    end
    
    if min(h.x(:,2)) < x2mn
        x2mn = min(h.x(:,2));
    end
    if max(h.x(:,2)) > x2mx
        x2mx = max(h.x(:,2));
    end
end

figure(1);
x1 = linspace(x1mn,x1mx,1000);
x2 = linspace(x2mn,x2mx,1000);
[ X1,X2 ] = meshgrid(x1,x2);
[ c,h ] = contour(X1,X2,f(X1,X2),20,'k','DisplayName','f(x)');
hold on;

kk = 1; % plot every kkth point
for ii = show_paths
    h = hs{ii};
    xopt = xopts(ii,:);
    fopt = fopts(ii);
    
    hx = h.x;
    hf = h.f;

    % Plot the paths for each starting point, x0ii
    plot(hx(1:kk:end,1),hx(1:kk:end,2),'.-','DisplayName',sprintf('x_{0%d}',ii));
end

plot(xopts(show_paths,1),xopts(show_paths,2),'kp','DisplayName','Optimums');
plot(0,0,'rp','DisplayName','x_{opt}');
legend(gca,'show')
title('f(x), paths for various starting points');
xlabel('x_1');
ylabel('x_2');

%% Cooling Curve
figure(2); hold on;
for ii = show_paths
    h = hs{ii};
    hf = h.f;
    plot(hf(1:n:end),'DisplayName',sprintf('x_{0%d}',ii));
end

legend(gca,'show');
title('Cooling curves for selected x_0');
xlabel('N');
ylabel('f(x)');

%% Misc Plot
figure(3); hold on;
% The same for all curves
h = hs{1};
hT = h.T;
plot(hT);

title('f eval vs T');
xlabel('Function Evaluations');
ylabel('T');