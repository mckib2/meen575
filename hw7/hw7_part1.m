%% Homework 7 - SQP Example
% Nicholas McKibben
% MEEn 575
% 2018-04-03

close all;
clear;

%% Explanation
% First, we'll define some helper functions that will take care of all the
% calculator stuff.  Then we'll quickly redo all the iterations up until
% the homework starts (Iteration 5).  We'll then do Iteration 5 and 6 with
% annotations.

%% Helper Functions

% This is our objective, f(x)
f = @(x) x(1)^4 - 2*x(2)*x(1)^2 + x(2)^2 + x(1)^2 - 2*x(1) + 5;

% It has a constraint, g(x)
g = @(x) -(x(1) + 1/4).^2 + (3/4).*x(2);

% Find the gradient of the objective
dfx1 = @(x) 4*x(1)^3 - 4*x(2)*x(1) + 2*x(1) - 2;
dfx2 = @(x) -2*x(1)^2 + 2*x(2);

% Also find the gradient of the constraint
dgx1 = @(x) -2*(x(1) + 1/4);
dgx2 = @(x) 3/4;

% This is the penalty function
pen = @(x,l) f(x) + l*abs(g(x));

% BFGS update stuff: gamma and bfgs
gamma = @(dff,dfp,dgf,dgp,l) (dff - l*dgf) - (dfp - l*dgp);
bfgs = @(gamma,dx,Hp) Hp + (gamma*gamma')/(gamma'*dx) - ...
    (Hp*dx*dx'*Hp)/(dx'*Hp*dx);

% Functions for fsolve - this is for positive lambda
ffun = @(x_,df_,L_,dg_,g_) ...
    [ df_(1) + L_(1,1)*x_(1) + L_(1,2)*x_(2) - x_(3)*dg_(1);
      df_(2) + L_(2,1)*x_(1) + L_(2,2)*x_(2) - x_(3)*dg_(2);
      g_ + dg_(1)*x_(1) + dg_(2)*x_(2) ];

% Function for fsolve - without gradient terms (lambda = 0)
ffuns = @(x_,df_,L_) ...
    [ df_(1) + L_(1,1)*x_(1) + L_(1,2)*x_(2);
      df_(2) + L_(2,1)*x_(1) + L_(2,2)*x_(2) ];

%% Iteration 1
x0 = [ -1 4 ]';
f0 = f(x0);
df0 = [ dfx1(x0) dfx2(x0) ]';
g0 = g(x0);
dg0 = [ dgx1(x0) dgx2(x0) ]';
L0 = eye(2);

% disp(table(x0,df0,dg0,L0));
% disp(table(f0,g0));

opts = optimoptions('fsolve','Display','off');
dx = fsolve(@(x) ffun(x,df0,L0,dg0,g0),[ 0 0 1 ],opts);

x1 = x0 + dx(1:2)';
pen0 = pen(x0,0);
pen1 = pen(x1,dx(3));

disp(table(x0,x1));

%% Iteration 2
f1 = f(x1);
df1 = [ dfx1(x1) dfx2(x1) ]';
g1 = g(x1);
dg1 = [ dgx1(x1) dgx2(x1) ]';

gamma0 = gamma(df1,df0,dg1,dg0,dx(3));
dx0 = x1 - x0;

L1 = bfgs(gamma0,dx0,L0);

% disp(table(df1,dg1,gamma0,dx0,L1));
% disp(table(f1,g1));

% dx = fsolve(@(x) ffun(x,df1,L1,dg1,g1),[ 0 0 1 ]);
dx = fsolve(@(x) ffuns(x,df1,L1),[ 0 0 ],opts);

% x2 = x1 + dx';
% pen2 = pen(x2,0);
x2 = x1 + 0.5*dx';
pen2 = pen(x2,0);

disp(table(x2));

%% Iteration 3
f2 = f(x2);
df2 = [ dfx1(x2) dfx2(x2) ]';
g2 = g(x2);
dg2 = [ dgx1(x2) dgx2(x2) ]';

gamma1 = gamma(df2,df1,dg2,dg1,0);
dx1 = x2 - x1;

L2 = bfgs(gamma1,dx1,L1);

% disp(table(x2,df2,dg2,gamma1));
% disp(table(dx1,L2));
% disp(table(f2,g2));

dx = fsolve(@(x) ffun(x,df2,L2,dg2,g2),[ 0 0 1 ],opts);

x3 = x2 + dx(1:2)';
pen3 = pen(x3,dx(3));

disp(table(x3));

%% Iteration 4
f3 = f(x3);
df3 = [ dfx1(x3) dfx2(x3) ]';
g3 = g(x3);
dg3 = [ dgx1(x3) dgx2(x3) ]';

gamma2 = gamma(df3,df2,dg3,dg2,dx(3));
dx2 = x3 - x2;

L3 = bfgs(gamma2,dx2,L2);

% disp(table(x3,df3,dg3,gamma2));
% disp(table(dx2,L3));
% disp(table(f3,g3));

dx = fsolve(@(x) ffun(x,df3,L3,dg3,g3),[ 0 0 1 ],opts);

x4 = x3 + dx(1:2)';
pen4 = pen(x4,dx(3));

disp(table(x4));

%% Iteration 5
fprintf('Starting Iteration 5 - It''s go time!\n\n');

fprintf('Let''s give the people an idea of where we''re starting from:\n\n');
disp(table(x3,df3,dg3,gamma2));
disp(table(dx2,L3));
disp(table(f3,g3));

fprintf('Alright, now find some values for this iteration:\n\n');
f4 = f(x4); % objective
df4 = [ dfx1(x4) dfx2(x4) ]'; % del f(x)
g4 = g(x4); % constraint
dg4 = [ dgx1(x4) dgx2(x4) ]'; % del g(x)
disp(table(f4,g4));
disp(table(df4,dg4));

fprintf('We need to do a Hessian update (Lagrangian update): find gamma and dx\n\n');
gamma3 = gamma(df4,df3,dg4,dg3,dx(3));
dx3 = x4 - x3;
disp(table(gamma3,dx3));

fprintf('Now usher in the new approximation in all it''s glory:\n\n');
L4 = bfgs(gamma3,dx3,L3);
disp(table(L4));

% disp(table(x4,df4,dg4,gamma3));
% disp(table(dx3,L4));
% disp(table(f4,g4));

% Now solve the system of equations
dx = fsolve(@(x) ffun(x,df4,L4,dg4,g4),[ 0 0 1 ],opts).';

fprintf('Here''s the system of equations we solved:\n\n');
fprintf('%f + %f*dx1 + %f*dx2 - l*%f = 0\n',df4(1),L4(1,1),L4(1,2),dg4(1));
fprintf('%f + %f*dx1 + %f*dx2 - l*%f = 0\n',df4(2),L4(2,2),L4(2,2),dg4(2));
fprintf('%f + %f*dx1 + %f*dx2 = 0\n\n',g4,dg4(1),dg4(2));
fprintf('And we got...\n\n');
disp(table(dx,'RowNames',{ 'dx1' 'dx2' 'lambda' }));

% Get the next point
x5 = x4 + dx(1:2);

% Let's decide if this point is good enough or we need to adjust step...
pen5 = pen(x5,dx(3));
if pen5 < pen4
    fprintf('Penalty is %f < last penalty of %f, so we''re moving on!\n',pen5,pen4);
else
    fprintf('You need to decrease your step! Penalty too big!\n');
end

%% Iteration 6

fprintf('Starting Iteration 6 - Huzzah!\n\n');

% Same kind of deal
f5 = f(x5);
df5 = [ dfx1(x5) dfx2(x5) ]';
g5 = g(x5);
dg5 = [ dgx1(x5) dgx2(x5) ]';

% Hessian update, BFGS
gamma4 = gamma(df5,df4,dg5,dg4,dx(3));
dx4 = x5 - x4;
L5 = bfgs(gamma4,dx4,L4);

fprintf('And now for some values at our new point and the Hessian update:\n\n');
disp(table(x5,df5,dg5));
disp(table(f5,g5));
disp(table(gamma4,dx4,L5));

% Let's solve the system of equations, shall we...
dx = fsolve(@(x) ffun(x,df5,L5,dg5,g5),[ 0 0 1 ],opts).';

fprintf('Here''s the system of equations we solved:\n\n');
fprintf('%f + %f*dx1 + %f*dx2 - l*%f = 0\n',df5(1),L5(1,1),L5(1,2),dg5(1));
fprintf('%f + %f*dx1 + %f*dx2 - l*%f = 0\n',df5(2),L5(2,2),L5(2,2),dg5(2));
fprintf('%f + %f*dx1 + %f*dx2 = 0\n\n',g5,dg5(1),dg5(2));
fprintf('And we got...\n\n');
disp(table(dx,'RowNames',{ 'dx1' 'dx2' 'lambda' }));

% Get us a new point:
x6 = x5 + dx(1:2);

% Let's decide if this new point is worth our time:
pen6 = pen(x6,dx(3));
if pen5 < pen4
    fprintf('Penalty is %f < last penalty of %f - so we''re golden!\n',pen5,pen4);
else
    fprintf('You need to decrease your step! Penalty too big!\n');
end

% Find the objective at the new point
f6 = f(x6);

fprintf('Looks like we have a good point, here you go:\n\n');
disp(table(x6));
disp(table(f6));

%% Let's Make a Pretty Plot
figure(1);

[ X1,X2 ] = meshgrid(linspace(-3,2,1000),linspace(-1,6,1000));
fplot = @(x1,x2) x1.^4 - 2.*x2.*x1.^2 + x2.^2 + x1.^2 - 2.*x1 + 5;
gplot = @(x1,x2) -(x1 + 1/4).^2 + (3/4).*x2;

contour(X1,X2,fplot(X1,X2),40,'k','DisplayName','f(x)');
hold on;
contour(X1,X2,gplot(X1,X2),[ 0 0 ],'r','DisplayName','g(x)');
[ ~,h ] = contour(X1,X2,gplot(X1,X2),ones(1,2)*.03,'r--','Linewidth',1.5);
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

X = [ x0(1) x1(1) x2(1) x3(1) x4(1) x5(1) x6(1) ];
Y = [ x0(2) x1(2) x2(2) x3(2) x4(2) x5(2) x6(2) ];
str = string(1:7);
plot(X,Y,'kx-','DisplayName','Resulting Steps','Linewidth',1.5);
text(X+.06,Y+.06,str);
title('The Path of the SQP Algorithm');
xlabel('x_1');
ylabel('x_2');
legend(gca,'show');

%% Comments
% At the first point, the search direction points away from the optimum,
% but after this first step, it is able to follow the gradient toward the
% optimum.  It appears to be quite efficient, getting close to the optimum
% only after 6 steps - especially considering the function is so eccentric
% near the optimum.  We reach x = [ 0.4740 0.6791 ] whereas the optimum
% lies at x = [ .5 .75 ].  We also notice that the SQP algorithm may step
% through infeasible points, thus we are not guaranteed a good point if we
% stop the algorithm early.