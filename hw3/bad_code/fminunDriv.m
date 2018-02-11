%% Homework 3
% Nicholas McKibben
% MEEn 575
% 2018-01-28

%---------------- Driver program for fminun------------------
clear;
close all;

global nobj ngrad;
nobj = 0; % counter for objective evaluations
ngrad = 0; % counter for gradient evaluations
x0 = [10 10 10].'; % starting point, set to be column vector

% Which algorithm to use
%     1 => steepest descent
%     2 => conjugate gradient
%     3 => BFGS quasi-Newton
algoflag = 2; 
stoptol = 1e-5; % stopping tolerance, all gradient elements must be < stoptol


% ---------- call fminun----------------
[xopt,fopt,exitflag] = fminun(@obj,@gradobj,x0,stoptol,algoflag);

% Show results
disp(table(x0,xopt));
disp(table(fopt,nobj,ngrad));

 % function to be minimized
 function [ f ] = obj(x)
    global nobj;
    %example function
    %f = 20 + 3*x(1) - 6*x(2) + 8*x(3)^2 + 6*x(1)^2 - 2*x(1)*x(2) - x(1)*x(3) + x(2)^2 + 0.5*x(3)^2;
    
    if (numel(x) < 4)
        x = [1; x];
    end
    A = 2*[ 0  0    0   0;
            0  6   -1  -1/2;
            0 -1    1   0;
            0 -1/2  0   1/2; ];
    B = -[ 20 3 -6 8 ].';
    f = (1/2)*x.'*A*x - x.'*B;
    nobj = nobj +1;
 end

% get gradient as a column vector
 function [ grad ] = gradobj(x)
    global ngrad;
    % gradient for function above
%     grad(1,1) = 12*x(1) - 2*x(2) - x(3) + 3;
%     grad(2,1) = -2*(x(1) - x(2) + 3);
%     grad(3,1) = -x(1) + x(3) + 8;

    x = [1; x];
    A = 2*[ 0  0    0   0;
            0  6   -1  -1/2;
            0 -1    1   0;
            0 -1/2  0   1/2; ];
    B = -[ 20 3 -6 8 ].';

    grad = A*x - B;

    ngrad = ngrad + 1;
 end

