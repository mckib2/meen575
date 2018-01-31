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
algoflag = 1;

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


[xopt,fopt,exitflag,h] = fminun(@obj,@grad,x0,stoptol,algoflag);
fprintf('Efficiency: %f\n',nobj + numel(x0)*ngrad);
disp(table(x0,xopt,grad(xopt)));
disp(table(fopt,exitflag,nobj,ngrad));


fprintf('We were actaully looking for...\n');
options = optimoptions('fminunc','Algorithm','trust-region','SpecifyObjectiveGradient',true,'StepTolerance',eps,'MaxFunctionEvaluations',500,'MaxIterations',Inf);
[ x,f ] = fminunc(@(x) fminunc_obj(x),x0,options);
disp(table(x0,x,grad(x)));
disp(table(f));



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

function [ f,g ] = fminunc_obj(x)
    f = obj(x);
    g = grad(x);
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

function [ xopt,fopt,exitflag,h ] = fminun(obj,grad,x0,stoptol,algoflag)
    global nobj;
    maxEval = 500;
    iter = 0;

    if algoflag == 1 % steepest descent
        
        % initial conditions
        x = x0;
        a = 0.15;

        while 1
            % Get the search direction
            g = grad(x);
            s = -g/norm(g);
            
            % Quadratic line search it up in here
            a = linesearch(a,x,s,obj);
            
            % Update
            x = x + a*s;
            
            % Check conditions
            if (all(abs(g) <= stoptol) || (nobj >= maxEval))
                fprintf('Steepest descent exiting...\n');
                break;
            end
            
            iter = iter + 1;
        end
    elseif algoflag == 2 % conjugate gradient
        
        % Initialize and perform first step (because we have no initial
        % conditions...)
        
        % Guess initial alpha and initial point
        a = 0.15;
        x = x0;
        
        % Find search direction (use steepest descent)
        g = grad(x);
        s = -g;
        
        % Qaudratic linesearch
        a = linesearch(a,x,s,obj);
        
        % Update
        x = x + a*s;
        
        % Initialize initial conditions
        gp = g;
        
        iter = 1; % That counted as an iteration
        while 1
            % Find the search direction
            g = grad(x);
            beta = dot(g,g)/dot(gp,gp);
            s = -g + beta*s;
            
            % Quadratic line search it up in here
            a = linesearch(a,x,s,obj);
            
            % Update
            x = x + a*s;
            
            % Update previous values for next iteration
            gp = g;

            % Check conditions
            if (all(abs(g) <= stoptol) || (nobj >= maxEval))
                fprintf('Conjugate gradient exiting...\n');
                break;
            end
            
            iter = iter + 1;
        end
        
    else % quasi-newton
        
        % Guess initial point and alpha
        x = x0;
        a = 0.15;
        
        % Find the search direction
        g = grad(x);
        N = eye(numel(x),numel(x)); % I
        s = -N*g;
        
        % Quadratic linesearch
        a = linesearch(a,x,s,obj);
        xp = x;
        
        % Update
        x = xp + a*s;
        
        % Get some initial conditions initialized
        dx = x - xp;
        Np = N;
        gp = g;
        
        iter = 1; % that counts as an iteration
        while 1
            
            % Let's find a search direction
            g = grad(x);
            gamma = g - gp;
            if (dx.'*gamma > 0)
                N = Np + (1 + (gamma.'*Np*gamma)/(dx.'*gamma))*((dx*dx.')/(dx.'*gamma)) - (dx*gamma.'*Np + Np*gamma*dx.')/(dx.'*gamma);
            else
                % ************************** Skip the update
                N = Np;
                %continue;
            end
            
            s = -N*g;
            
            % Quadratic linesearch
            a = linesearch(a,x,s,obj);
            
            % Update
            xp = x;
            x = xp + a*s;
            
            % Get things ready for the next time around
            dx = x - xp;
            Np = N;
            gp = g;
            
            % Check conditons
            if (all(abs(g) <= stoptol) || (nobj >= maxEval))
                fprintf('BFGS exiting...\n');
                break;
            end
            
            iter = iter + 1;
        end
    end

    % Get all the output nice and wrapped up
    xopt = x;
    fopt = obj(xopt);
    fprintf('Total iterations: %d\n',iter);
    
    if (nobj > maxEval)
        exitflag = 1;
    else
        exitflag = 0;
    end
    
    % Collect all the history and package it up real nice
    h = [];
end

function [ a ] = linesearch(a,x,s,obj)
    f1 = obj(x + a*s);
    f2 = obj(x + 2*a*s);
    f3 = obj(x + 4*a*s);
    a = (f1*(4*a^2 - 16*a^2) + f2*(16*a^2 - a^2) + f3*(a^2 - 4*a^2))/ ...
        (2*(f1*(2*a - 4*a) + f2*(4*a - a) + f3*(a - 2*a)));
end