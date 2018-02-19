clear;
close all;


% ------------Starting point and bounds------------
% x = [ density comp, kernel width, tolerance, oversampling factor ]
x0 = [ 1e4  80   1e-5, 10,   1e-8, 1.5 ];
ub = [ 1e5  Inf, 1,    Inf, 1e-2, Inf ];
lb = [ 1,   0,   0,    1,   1e-8, 1   ];

% ------------Linear constraints------------
A = [];
b = [];
Aeq = [];
beq = [];

% ------------Call fmincon------------
options = optimoptions(@fmincon,'display','iter-detailed','algorithm','sqp','FiniteDifferenceType','central');
[xopt,fopt,exitflag,output] = fmincon(@obj,x0,A,b,Aeq,beq,lb,ub,@con,options);


function [ c,ceq ] = con(x)
%     c(1) = mod(x(2),1); % kernel width is an integer

    c = [];
%     c(1) = x(2)

    ceq = [];
end
