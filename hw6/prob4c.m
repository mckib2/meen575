%% Problem 4c
% Nicholas McKibben
% MEEn 575
% 2018-03-27

clear;
close all;

% From the contour plot we can see that the optimum point has constraint g2
% binding, so we have:
%
%     min f(x) = x(1)^2 + x(2)
%     s.t. g2(x) = -x(1) - x(2)^2 + 1 = 0 (binding)
%
% Let's solve for the KKT equations:
% df/dx(1) = 2*x(1)    df/dx(2) = 1
% dg/dx(1) = -1        dg/dx(2) = -2*x(2)
%
% Set up our system of equations to solve
%     x(1) -- x1
%     x(2) -- x2
%     x(3) -- lambda
nonlinfuns = @(x) [ 2*x(1) + x(3)
                    1 + x(3)*2*x(2)
                   -(x(1) + x(2)^2 - 1) ];

% Choose a starting point around where we think the optimum is from the
% contour plot
x0 = [ 0 -1 0 ];
[ xopt ] = fsolve(nonlinfuns,x0);
f = @(x) x(1)^2 + x(2);
fopt = f(xopt);
xopt = xopt(:);
labels = [ "x1" "x2" "l" ].';

% Let's look at it
disp(table(labels,xopt));
fprintf('Optimum at (%f,%f) with f = %f, lambda is positive so we''re good!\n', ...
    xopt(1),xopt(2),fopt);