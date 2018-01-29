clear;
close all;

global nobj ngrad testflag;
nobj = 0;
ngrad = 0;

% 1 => quadratic
% 2 => rosenbrocks
% 3 => book example
testflag = 1;

% 1 => steepest descent
% 2 => conjugate gradient
% 3 => BFGS
algoflag = 2;

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


[xopt,fopt,exitflag] = fminun(@obj,@grad,x0,stoptol,algoflag);
disp(table(x0,xopt));
disp(table(fopt,exitflag,nobj,ngrad));
fprintf('Efficiency: %f\n',nobj + numel(x0)*ngrad);


fprintf('We were actaully looking for...\n');
options = optimoptions('fminunc','Algorithm','trust-region','SpecifyObjectiveGradient',true);
[ x,f ] = fminunc(@(x) fminunc_obj(x),x0,options);
disp(table(x0,x));
disp(table(f));



function [ f ] = obj(x)
    global nobj testflag;

    if testflag == 1
        f = 20 + 3*x(1) - 6*x(2) + 8*x(3)^2 + 6*x(1)^2 - 2*x(1)*x(2) - x(1)*x(3) + x(2)^2 + 0.5*x(3)^2;
    elseif testflag == 2
        f = 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
    elseif testflag == 3
        f = x(1)^2 - 2*x(1)*x(2) + 4*x(2)^2;
    end
    
    nobj = nobj + 1;
end

function [ f,g ] = fminunc_obj(x)
    global testflag;
    
    if testflag == 1
        f = 20 + 3*x(1) - 6*x(2) + 8*x(3)^2 + 6*x(1)^2 - 2*x(1)*x(2) - x(1)*x(3) + x(2)^2 + 0.5*x(3)^2;
        
        g(1,1) = 12*x(1) - 2*x(2) - x(3) + 3;
        g(2,1) = -2*(x(1) - x(2) + 3);
        g(3,1) = -x(1) + x(3) + 8;
    elseif testflag == 2
        f = 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
        
        g(1,1) = -400*(x(2) - x(1)^2)*x(1) - 2*(1 - x(1));
        g(2,1) = 200*(x(2) - x(1)^2);
    elseif testflag == 3
        f = x(1)^2 - 2*x(1)*x(2) + 4*x(2)^2;
        
        g(1,1) = 2*x(1) - 2*x(2);
        g(2,1) = -2*x(1) + 8*x(2);
    end
end

function [ g ] = grad(x)
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

function [ xopt,fopt,exitflag ] = fminun(obj,grad,x0,stoptol,algoflag)
    global nobj;
    maxEval = 500;
    iter = 0;
    
    % initial conditions
    x = x0;
    a = 0.4;
    g = grad(x);
    
    if algoflag == 1 % steepest descent
        
        % Do one iteration with standard gradient descent
        a = linesearch(a,-g/norm(g),x,obj);
        x = x - a*g/norm(g);
        iter = 1;
        
        while (any(abs(g) > stoptol) && (nobj <= maxEval))
            g = grad(x);
            s = -g/norm(g);
            a = linesearch(a,s,x,obj);
            x = x + a*s;

            iter = iter + 1;
        end
    elseif algoflag == 2 % conjugate gradient
        
        s = -g;
        xn = x + a*s;
        
        xp = x;
        x = xn;
        f = obj(x);
        gp = g;
        sp = s;
        
        iter = 1;
        while (any(abs(g) > stoptol) && (nobj <= maxEval))
            g = grad(x);
            beta = g.'*g/(gp.'*gp);
            s = -g + beta*sp;
            %a = (x - xp)'*(g - gp)/norm(g - gp)^2; % Baizilai-Borwein method
            a = .1;
            xn = x + a*s;
            
            fn = obj(xn);
            if (fn > f)
                s = -x + xp;
                xn = x + a*s;
                fn = obj(xn);
            end
            
            gp = g;
            xp = x;
            x = xn;
            f = fn;
            sp = s;
            
            iter = iter + 1;
        end
        
    else % quasi-newton
    end

    xopt = x;
    fopt = obj(xopt);
    fprintf('Total iterations: %d\n',iter);
    
    if (nobj > maxEval)
        exitflag = 1;
    else
        exitflag = 0;
    end
end

function [ a ] = linesearch(a,s,x0,obj)
    x = zeros(numel(x0),10);
    x(:,1) = x0;
    a(1) = a;

    f(1) = obj(x(:,1));
    x(:,2) = x(:,1) + a(1)*s;
    f(2) = obj(x(:,2));
   
    idx = 3;
    while (f(end) < f(end-1))
        a(idx-1) = a(idx-2)*2;
        x(:,idx) = x(:,1) + a(idx-1)*s;
        f(idx) = obj(x(:,idx));
        
        idx = idx + 1;
    end
   
    
    if (numel(f) >= 3)
    
        a(idx-1) = (a(idx-2) + a(idx-3))/2;
        x(:,idx) = x(:,1) + a(idx-1)*s;
        f(idx) = obj(x(:,idx));
        
        % This means it's not convex
        if (f(end) < f(end-2))
            [ ~,idx ] = min(f);
            a = a(idx-1);
            return;
        end

        % Take the point with the lowest function value
        [ f2,idx ] = min(f);
        a2 = a(idx-1);
        
        f1 = f(idx-1);
        f3 = f(idx+1);

        da = a(2)-a(1);

        a = a2 + (da*(f1 - f3))/(2*(f1 - 2*f2 + f3));
    else
        [ ~,idx ] = min(f);
        a = a(idx);
    end
end