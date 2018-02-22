clear;
close all;


% ------------Starting point and bounds------------
% x = [ turns, density comp, kernel width, tolerance, oversampling factor ]
x0 = [ 9    1e-5, 2,   1e-3,  2.5 ];
% x0 = [ 8, 1e-5, 2,   1e-3,  2.5 ];
ub = [ Inf, 1,    25,  1e-2,  3   ];
lb = [ 1,   0,    1,   1e-6,  1   ];

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

    TR = 3e-3*6;
    
    kosf = 0.91/(x(5)*x(4));
    kwidth = x(5)*x(3)/2;
    
    c = [];
    c(1) = 2 - 1/(TR*x(1));
    c(2) = 1 - kosf*kwidth;
    c(3) = kosf*kwidth - 1e4;
    
    ceq = [];
end
