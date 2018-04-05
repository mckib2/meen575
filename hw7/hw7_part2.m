%% Homework 7 - IP Example
% Nicholas McKibben
% MEEn 575
% 2018-04-03

close all;
clear;

%% Explanation
% First, we'll define some helper functions that will take care of all the
% calculator stuff.  Then we'll quickly redo all the iterations up until
% the homework starts (Iteration 3).  We'll then do Iteration 3 with
% annotations.

%% Helper Functions

% This is f(x) 
f = @(x) x(1)^4 - 2*x(2)*x(1)^2 + x(2)^2 + x(1)^2 - 2*x(1) + 5;
% This is the only constraint, g(x)
g = @(x) -(x(1) + 1/4)^2 + (3/4)*x(2);

% This is df/dx1, or the derivative of f(x) with respect to x1
dfx1 = @(x) 4*x(1)^3 - 4*x(2)*x(1) + 2*x(1) - 2;
% This is df/dx2, or the derivative of f(x) with respect to x2
dfx2 = @(x) -2*x(1)^2 + 2*x(2);

% Now we do the same for g(x) (find the derivates w.r.t. x1 and x2).
dgx1 = @(x) -2*(x(1) + 1/4);
dgx2 = @(x) 3/4;

% Define our f_{\mu}(x) - has a barrier term
fmu = @(x,mu,s) f(x) - mu*log(s);
% This is the constraint with slack variable s encorporated, g_s(x)
gs = @(x,s) -(x(1) + (1/4))^2 + (3/4)*x(2) - s;

% Let's find a coefficient matrix.
% This is building this matrix:
%    ( del_x^2L     0    (-J)^T    )
%    (     0     \Lambda   S       )
%    (     J       -I      0       )
coef_matrix = @(L,J,l,s) [ L zeros(size(L,1),size(l,2)) -J; zeros(size(l,1),size(L,2)) l s; J.' -eye(size(J,2),size(l,2)) zeros(size(J,2),size(l,2)) ];

% Now define the residue vector:
res = @(x,l,s,mu) -[ [ dfx1(x) dfx2(x) ].' - l*[ dgx1(x) dgx2(x) ].'; s*l - mu; g(x) - s ];

% We also need a penalty function:
pen = @(x,l) f(x) + l*abs(g(x));

% Let's get gamma to use with the BFGS update:
gamma = @(dff,dfp,dgf,dgp,l) (dff - l*dgf) - (dfp - l*dgp);

% Now let's get the BFGS update:
bfgs = @(gamma,dx,Hp) Hp + (gamma*gamma')/(gamma'*dx) - ...
    (Hp*dx*dx'*Hp)/(dx'*Hp*dx);

%% Start
x0 = [ -1 4 ]';
f0 = f(x0);
g0 = g(x0);
df0 = [ dfx1(x0) dfx2(x0) ]';
dg0 = [ dgx1(x0) dgx2(x0) ]';

L0 = eye(2);
J0 = dg0;

mu0 = 5;
s0 = g0;
l0 = 2;
pen0 = pen(x0,0);

% disp(table(x0,df0,dg0,L0,J0));
% disp(table(f0,g0,mu0,s0,l0,pen0));
disp(table(x0));

%% First Iteration

A = coef_matrix(L0,J0,l0,s0);
b = res(x0,l0,s0,mu0);
dvars = A\b;

% disp(table(A,b));
% disp(table(dvars));

s1 = s0 + dvars(end-1)*.748;
x1 = x0 + dvars(1:2)*.748;
l1 = l0 + dvars(end);
mu1 = mu0/5;

f1 = f(x1);
pen1 = pen(x1,l1);

disp(table(x1));

%% Second Iteration

df1 = [ dfx1(x1) dfx2(x1) ].';
g1 = g(x1);
dg1 = [ dgx1(x1) dgx2(x1) ].';

% disp(table(x1,df1,dg1));
% disp(table(g1,s1,l1,f1,pen1));

dx0 = x1 - x0;
gamma0 = gamma(df1,df0,dg1,dg0,l1);
L1 = bfgs(gamma0,dx0,L0);
J1 = dg1;

% disp(table(dx0,gamma0,L1));

A = coef_matrix(L1,J1,l1,s1);
b = res(x1,l1,s1,mu1);
dvars = A\b;

% disp(table(A,b));
% disp(table(dvars));

x2 = x1 + dvars(1:2);
s2 = s1 + dvars(3);
l2 = 0;
f2 = f(x2);
g2 = g(x2);
mu2 = mu1/5;

pen2 = pen(x2,l2);

disp(table(x2));

%% Iteration 3

fprintf('Starting Iteration 3...\n');

% Let's find our new del f(x) and del g(x) with new point x2 found in the
% previous iteration
df2 = [ dfx1(x2) dfx2(x2) ].';
dg2 = [ dgx1(x2) dgx2(x2) ].';

fprintf('Let''s show everyone what we''re starting out with:\n\n');
disp(table(x2,df2,dg2));
disp(table(g2,s2,l2,f2,pen2));

% Let's get our Hessian update using BFGS:
dx1 = x2 - x1;
gamma1 = gamma(df2,df1,dg2,dg1,l2);
L2 = bfgs(gamma1,dx1,L1);

% The Jacobian happens to just be del g(x)
J2 = dg2;

fprintf('BFGS Hessian Update:\n\n');
disp(table(dx1,gamma1,L2));

% Now we need to set up our KKT matrix and sovle it.  We'll use the
% backslash operator to solve this nice and quick:
A = coef_matrix(L2,J2,l2,s2); % matrix of coefficients
b = res(x2,l2,s2,mu2); % residue
dvars = A\b; % solution

fprintf('Coefficient matrix A, residue b, and solution vector dvars:\n\n');
disp(table(A,b));
disp(table(dvars));

% Let's get the new values
x3 = x2 + dvars(1:2);
s3 = s2 + dvars(3);
l3 = l2 + dvars(4);
f3 = f(x3);
g3 = g(x3);
mu3 = mu1/5;

pen3 = pen(x3,l3);

fprintf('It looks like s, lambda are positive (that''s good) and our penalty function is lower than previous iteration, so we''re a go!\n\n');
disp(table(s3,l3,f3,g3,pen3));
disp(table(x3));

%% Let's Make a Pretty Plot
figure(1);

[ X1,X2 ] = meshgrid(linspace(-3,2,1000),linspace(-1.5,6,1000));
fplot = @(x1,x2) x1.^4 - 2.*x2.*x1.^2 + x2.^2 + x1.^2 - 2.*x1 + 5;
gplot = @(x1,x2) -(x1 + 1/4).^2 + (3/4).*x2;

contour(X1,X2,fplot(X1,X2),40,'k','DisplayName','f(x)');
hold on;
contour(X1,X2,gplot(X1,X2),[ 0 0 ],'r','DisplayName','g(x)');
[ ~,h ] = contour(X1,X2,gplot(X1,X2),ones(1,2)*.03,'r--','Linewidth',1.5);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

X = [ x0(1) x1(1) x2(1) x3(1) ];
Y = [ x0(2) x1(2) x2(2) x3(2) ];
str = string(1:4);
plot(X,Y,'kx-','DisplayName','Resulting Steps','Linewidth',1.5);
text(X+.06,Y+.06,str);
title(' The Progress of the IP Algorithm');
xlabel('x_1');
ylabel('x_2');
legend(gca,'show');

%% Comments
% We notice that our IP algorithm jumps around a little more than the SQP
% (or MATLAB's IP implementation for that matter).  This is probably due to
% our unsophisticated linesearch method.  Again, we find that we step
% through infeasible points, and as mu becomes smaller with each iteration
% we drive the product of lambda and g(x) to 0, driving the solution into a
% feasible region.  At each iteration, we find that we are in the same
% ballpark as the SQP algorithm at the same iteration.  We conclude that
% the performance of SQP and IP are comparable for this size of problem.
% It's interesting to note that the IP algorithm relies on a least squares
% solution whereas SQP uses a Newton-Raphson zero solver to solve systems
% of equations.