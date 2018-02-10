function [] = fminunDriv()
%----------------Example Driver program for fminun------------------
    clear;
    close all;

    global nobj ngrad testflag
    nobj = 0; % counter for objective evaluations
    ngrad = 0.; % counter for gradient evaluations
    
    % 1 => quadratic
    % 2 => rosenbrocks
    % 3 => book example
    testflag = 2;
    
    % 1 => steepest descent
    % 2 => conjugate gradient
    % 3 => BFGS
    algoflag = 3;
    
    if testflag == 1
        x0 = [10,10,10].';
        stoptol = 1e-5;
    elseif testflag == 2
        x0 = [-1.5,1].';
        stoptol = 1e-3;
    elseif testflag == 3
        x0 = [-3,1].';
        stoptol = 1e-3;
    end
    
    % ---------- call fminun----------------
    [xopt, fopt, exitflag] = fminun(@obj, @gradobj, x0, stoptol, algoflag);
   
    xopt
    fopt
    
    nobj
    ngrad
end

function [ f ] = obj(x)
    global nobj testflag;

    if testflag == 1
        f = 20 + 3*x(1) - 6*x(2) + 8*x(3) + 6*x(1)^2 - 2*x(1)*x(2) - x(1)*x(3) + x(2)^2 + 0.5*x(3)^2;
    elseif testflag == 2
        f = 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
    elseif testflag == 3
        f = x(1)^2 - 2*x(1)*x(2) + 4*x(2)^2;
    end
    
    nobj = nobj + 1;
end


function [ g ] = gradobj(x)
    global ngrad testflag;
    
    if testflag == 1
        g(1,1) = 12*x(1) - 2*x(2) - x(3) + 3;
        g(2,1) = -2*(x(1) - x(2) + 3);
        g(3,1) = -x(1) + x(3) + 8;
    elseif testflag == 2
        g(1,1) = -400*(x(2) - x(1)^2)*x(1) - 2*(1 - x(1));
        g(2,1) = 200*(x(2) - x(1)^2);
    elseif testflag == 3
        g(1,1) = 2*x(1) - 2*x(2);
        g(2,1) = -2*x(1) + 8*x(2);
    end
    
    ngrad = ngrad + 1;
end

    