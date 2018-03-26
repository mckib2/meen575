%% Homework 6: KKT Conditions, LaGrange Multipliers
% Nicholas McKibben
% MEEn 575
% 2018-03-25

clear;
close all;

%% (1a) KKT Equations with equality constraint
% Let's get symbolic up in here
syms f(x1,x2) g(x1,x2)
f(x1,x2) = 4*x1 - 3*x2 +2*x1.^2 - 3*x1*x2 + 4*x2.^2;
g(x1,x2) = 2*x1 - 1.5*x2 - 5;

% Solve the KKT equations to get A,b
[ A1a,b1a ] = solveKKT(f,g);

% Get the optimal x values and lambda:
x1a = A1a\b1a;

fprintf('(1a) Optimum is at (%f,%f) with f = %f and lambda = %f\n', ...
    x1a(1),x1a(2),f(x1a(1),x1a(2)),x1a(3));

% % Use fmincon to double check that the we did the right thing
% ff = @(x) double(f(x(1),x(2)));
% [ xopt,fopt ] = fmincon(ff,[ 0 5/-1.5 ],[],[],[ 2 -1.5 ],5);

%% (1b) Change constraints

g(x1,x2) = 2*x1 - 1.5*x2 - 5.1;

% Solve the KKT equations to get A,b
[ A1b,b1b ] = solveKKT(f,g);

% Get the optimal x values and lambda:
x1b = A1b\b1b;

fprintf('(1b) Optimum is at (%f,%f) with f = %f and lambda = %f\n', ...
    x1b(1),x1b(2),f(x1b(1),x1b(2)),x1b(3));

% % Use fmincon to double check that the we did the right thing
% ff = @(x) double(f(x(1),x(2)));
% [ xopt,fopt ] = fmincon(ff,[ 0 5/-1.5 ],[],[],[ 2 -1.5 ],5.1);

%% (1c)
% Are the KKT equations for a problem with with a quadratic objective and a
% linear equality constraint always linear?  Is this true for a problem
% with a quadratic objective and a linear inequality constraint?

% (skip 2)?
%% (3) KKT Equations with equality and inequality constraints

