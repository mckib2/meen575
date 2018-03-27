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
[ A1a,b1a ] = solveKKT(f,{ g });

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
[ A1b,b1b ] = solveKKT(f,{ g });

% Get the optimal x values and lambda:
x1b = A1b\b1b;

fprintf('(1b) Optimum is at (%f,%f) with f = %f and lambda = %f\n', ...
    x1b(1),x1b(2),f(x1b(1),x1b(2)),x1b(3));

% % Use fmincon to double check that the we did the right thing
% ff = @(x) double(f(x(1),x(2)));
% [ xopt,fopt ] = fmincon(ff,[ 0 5/-1.5 ],[],[],[ 2 -1.5 ],5.1);

% Does the Lagrange multiplier from (a) accurately  predict the change in
% the objective?
dcon = .1;
expected_diff = dcon*x1a(3);
actual_diff = abs(f(x1a(1),x1a(2)) - f(x1b(1),x1b(2)));

fprintf('\nChange in constraint: %f\n',dcon);
fprintf('Expected change using Lagrange multiplier: %f\n',expected_diff);
fprintf('Actual change in f: %f\n',actual_diff);
fprintf('So we were %f off, which is pretty good, I think.\n\n', ...
    abs(actual_diff - expected_diff));

%% (1c)
% Are the KKT equations for a problem with with a quadratic objective and a
% linear equality constraint always linear?  Is this true for a problem
% with a quadratic objective and a linear inequality constraint?

% (skip 2)?
%% (3) KKT Equations with equality and inequality constraints
syms x3

% Objective
f(x1,x2,x3) = x1^2 + 2*x2^2 + 3*x3^2;

% Equality constraints, g
g1(x1,x2,x3) = x1 + 5*x2 - 12;

% Inequality constraints, h
g2(x1,x2,x3) = -(-2*x1 + x2 -4*x3 + 18);

[ A3a,b3a ] = solveKKT(f,{ g1 g2 });
x3a = A3a\b3a;

fprintf('(3) Optimum is at (%f,%f,%f) with f = %f\n', ...
    x3a(1),x3a(2),x3a(3),f(x3a(1),x3a(2),x3a(3)));

% Is this actually an optimum?
xstar = [ x3a(1) x3a(2) x3a(3) ];
[ l,lambdas ] = verifyKKT(f,{ g1 g2 },xstar);

fprintf('Lambdas are positive, so we think we''re right:\n');
disp(table(l,lambdas));

% % Use fmincon to double check that the we did the right thing
% ff = @(x) double(f(x3a(1),x3a(2),x3a(3)));
% [ xopt,fopt ] = fmincon(ff,[ x3a(1) x3a(2) x3a(3) ],[ -2 1 -4 ],18,[ 1 5 0 ],12);

%% (4) Verification of optimum using KKT Equations
%% (a) Verify point is local optimum

f(x1,x2) = x1^2 + x2;
g1(x1,x2) = x1^2 + x2^2 - 9;
g2(x1,x2) = -(x1 + x2^2 - 1);
g3(x1,x2) = -(x1 + x2 - 1);

% Look at the graph to see which constraints are binding at
% [ -2.3723 -1.8364 ]
% g1,g2 are binding, so use those ones

xstar = [ -2.3723 -1.8364 ];
[ l,lambdas ] = verifyKKT(f,{ g1 g2 },xstar);

fprintf('(4a) Lambdas are:\n');
disp(table(l,lambdas));

%% (b) Verify a point is not the optimum
% We only have one binding condition - the equality condition - at this
% point, looking at the contour plot.
xstar = [ -2.5000 -1.6583 ];
[ l,lambdas ] = verifyKKT(f,{ g1 },xstar);

fprintf('(4b) Lambda is inconsistent, thus KKT not satisfied:\n');
disp(table(l,lambdas));

%% (c) Solve for optimum excluding equality constraint
% Looking at the contour plot, we expect g2 to be the only binding
% constraint.
% TODO: We need a KKT solver that can handle nonlinear constraints...