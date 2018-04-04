%% Homework 7 - SQP Example
% Nicholas McKibben
% MEEn 575
% 2018-04-03

close all;
clear;

%% Helper Functions
f = @(x) x(1)^4 - 2*x(2)*x(1)^2 + x(2)^2 + x(1)^2 - 2*x(1) + 5;
g = @(x) -(x(1) + 1/4)^2 + (3/4)*x(2);

dfx1 = @(x) 4*x(1)^3 - 4*x(2)*x(1) + 2*x(1) - 2;
dfx2 = @(x) -2*x(1)^2 + 2*x(2);

dgx1 = @(x) -2*(x(1) + 1/4);
dgx2 = @(x) 3/4;

pen = @(x,l) f(x) + l*abs(g(x));

gamma = @(dff,dfp,dgf,dgp,l) (dff - l*dgf) - (dfp - l*dgp);
bfgs = @(gamma,dx,Hp) Hp + (gamma*gamma')/(gamma'*dx) - ...
    (Hp*dx*dx'*Hp)/(dx'*Hp*dx);

% Positive lambda
ffun = @(x_,df_,L_,dg_,g_) ...
    [ df_(1) + L_(1,1)*x_(1) + L_(1,2)*x_(2) - x_(3)*dg_(1);
      df_(2) + L_(2,1)*x_(1) + L_(2,2)*x_(2) - x_(3)*dg_(2);
      g_ + dg_(1)*x_(1) + dg_(2)*x_(2) ];

% Without gradient (lambda = 0)
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

disp(table(x0,df0,dg0,L0));
disp(table(f0,g0));

dx = fsolve(@(x) ffun(x,df0,L0,dg0,g0),[ 0 0 1 ]);

x1 = x0 + dx(1:2)';
pen0 = pen(x0,0);
pen1 = pen(x1,dx(3));

%% Iteration 2
f1 = f(x1);
df1 = [ dfx1(x1) dfx2(x1) ]';
g1 = g(x1);
dg1 = [ dgx1(x1) dgx2(x1) ]';

gamma0 = gamma(df1,df0,dg1,dg0,dx(3));
dx0 = x1 - x0;

L1 = bfgs(gamma0,dx0,L0);

disp(table(df1,dg1,gamma0,dx0,L1));
disp(table(f1,g1));

% dx = fsolve(@(x) ffun(x,df1,L1,dg1,g1),[ 0 0 1 ]);
dx = fsolve(@(x) ffuns(x,df1,L1),[ 0 0 ]);

% x2 = x1 + dx';
% pen2 = pen(x2,0);
x2 = x1 + 0.5*dx';
pen2 = pen(x2,0);

%% Iteration 3
f2 = f(x2);
df2 = [ dfx1(x2) dfx2(x2) ]';
g2 = g(x2);
dg2 = [ dgx1(x2) dgx2(x2) ]';

gamma1 = gamma(df2,df1,dg2,dg1,0);
dx1 = x2 - x1;

L2 = bfgs(gamma1,dx1,L1);

disp(table(x2,df2,dg2,gamma1));
disp(table(dx1,L2));
disp(table(f2,g2));

dx = fsolve(@(x) ffun(x,df2,L2,dg2,g2),[ 0 0 1 ]);

x3 = x2 + dx(1:2)';
pen3 = pen(x3,dx(3));

%% Iteration 4
f3 = f(x3);
df3 = [ dfx1(x3) dfx2(x3) ]';
g3 = g(x3);
dg3 = [ dgx1(x3) dgx2(x3) ]';

gamma2 = gamma(df3,df2,dg3,dg2,dx(3));
dx2 = x3 - x2;

L3 = bfgs(gamma2,dx2,L2);

disp(table(x3,df3,dg3,gamma2));
disp(table(dx2,L3));
disp(table(f3,g3));

dx = fsolve(@(x) ffun(x,df3,L3,dg3,g3),[ 0 0 1 ]);

x4 = x3 + dx(1:2)';
pen4 = pen(x4,dx(3));

%% Iteration 5
f4 = f(x4);
df4 = [ dfx1(x4) dfx2(x4) ]';
g4 = g(x4);
dg4 = [ dgx1(x4) dgx2(x4) ]';

gamma3 = gamma(df4,df3,dg4,dg3,dx(3));
dx3 = x4 - x3;

L4 = bfgs(gamma3,dx3,L3);

disp(table(x4,df4,dg4,gamma3));
disp(table(dx3,L4));
disp(table(f4,g4));

dx = fsolve(@(x) ffun(x,df4,L4,dg4,g4),[ 0 0 1 ]);

x5 = x4 + dx(1:2)';
pen5 = pen(x5,dx(3));

if pen5 < pen4
    fprintf('Penalty is %f < last penalty of %f\n',pen5,pen4);
else
    fprintf('You need to decrease your step! Penalty too big!\n');
end

%% Iteration 6
f5 = f(x5);
df5 = [ dfx1(x5) dfx2(x5) ]';
g5 = g(x5);
dg5 = [ dgx1(x5) dgx2(x5) ]';

gamma4 = gamma(df5,df4,dg5,dg4,dx(3));
dx4 = x5 - x4;

L5 = bfgs(gamma4,dx4,L4);

disp(table(x5,df5,dg5,gamma4));
disp(table(dx4,L5));
disp(table(f5,g5));

dx = fsolve(@(x) ffun(x,df5,L5,dg5,g5),[ 0 0 1 ]);

x6 = x5 + dx(1:2)';
pen6 = pen(x6,dx(3));

if pen5 < pen4
    fprintf('Penalty is %f < last penalty of %f\n',pen5,pen4);
else
    fprintf('You need to decrease your step! Penalty too big!\n');
end

f6 = f(x6);

disp(table(x6));
disp(table(f6));