
function [xopt,fopt,exitflag] = fminun(obj,grad,x0,stoptol,algoflag)

    % Objective function LUT
    global LUT keyfmt nobj_saved;
    LUT = containers.Map();
    keyfmt = '%.53f %.53f %.53f';
    nobj_saved = 0;

    global nobj ls;

    % 1 => quadratic line search (only fits 3 points)
    % 2 => exact line search (as in book)
    % 3 => iterative exact line search (best)
    % 4 => Golden section algorithm
    % 5 => Inexact
    ls = 3;

    maxEval = 500;
    iter = 0;

    if algoflag == 1 % steepest descent
        
        % initial conditions
        x = x0;
        h.x(:,1) = x;
        
        % iter_linsearch always starts with a0 = 1, but other methods may
        % have an initial guess given in arguments
        a = .15;
        
        % nonmonotonic initial conditions
        if ls == 4
            C(1) = lookup(x0,obj);
        else
            C = [];
        end
        Q(1) = 1;

        while 1
            % Get the search direction
            g = grad(x);
            s = -g;
            
            % Do linesearch to get the step size, set by global flag, `ls`
            [ a,C,Q ] = stepsize(x,s,a,obj,C,Q,g);
            
            % Update
            x = x + a*s;
            
            % Save the history
            h.x(:,iter+2) = x;
            
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
        
        % monotonic line search initializations
        if ls == 4
            C(1) = lookup(x0,obj);
        else
            C = [];
        end
        Q(2) = 1;
        

        % Find search direction (use steepest descent)
        x = x0;
        h.x(:,1) = x;
        g = grad(x);
        s = -g;
        
        % Get the stepsize using the linesearch method given by ls flag
        [ a,C,Q ] = stepsize(x,s,a,obj,C,Q,g);
        
        % Update
        x = x + a*s;
        h.x(:,2) = x;
        
        % Initialize initial conditions
        gp = g;
        
        iter = 1; % That counted as an iteration
        while 1
            % Find the search direction
            g = grad(x);
            beta = dot(g,g)/dot(gp,gp);
            s = -g + beta*s;

            [ a,C,Q ] = stepsize(x,s,a,obj,C,Q,g);
            
            % Update
            x = x + a*s;
            h.x(:,iter+2) = x;
            
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
        
        % nonmonotonic line search initialization
        if ls == 4
            C(1) = lookup(x0,obj);
        else
            C = [];
        end
        Q(2) = 1;
        
        % Find the search direction
        g = grad(x);
        N = eye(numel(x),numel(x)); % I
        s = -N*g;

        print_head();
        print_iter(iter,lookup(x,obj),0,norm(g,Inf));
        
        % Line search to get stepsize
        [ a,C,Q ] = stepsize(x,s,a,obj,C,Q,g);
        
        xp = x;
        h.x(:,1) = xp;
        
        % Update
        x = xp + a*s;
        h.x(:,2) = x;
        
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
                % Skip the update of N
                N = Np;
            end
            
            s = -N*g;
            
            % Do the linesearch
            [ a,C,Q ] = stepsize(x,s,a,obj,C,Q,g);
            
            % Update
            xp = x;
            x = xp + a*s;
            h.x(:,iter+2) = x;
            
            % Get things ready for the next time around
            dx = x - xp;
            Np = N;
            gp = g;
            
            print_iter(iter,lookup(xp,obj),a,norm(gp,Inf));
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
    fopt = lookup(xopt,obj);
    fprintf('Total iterations: %d\n',iter);
    
    if (nobj > maxEval)
        exitflag = 1;
    else
        exitflag = 0;
    end
    
    %% Let's look at how everything went
    figure(1);
    [X,Y] = meshgrid(linspace(min(h.x(1,:))-1,max(h.x(1,:)+1)), ...
        linspace(min(h.x(2,:))-1,max(h.x(2,:))+1));
    if numel(x0) > 2
        Z = meshgrid(linspace(min(h.x(3,:))-1,max(h.x(3,:))+1));
    else
        Z = [];
    end
    f = cobj(X,Y,Z);
    contour(X,Y,f); hold on;
    plot(h.x(1,:),h.x(2,:),'.-');
end

function [ a ] = linesearch(a,x,s,obj)
    f1 = obj(x + a*s);
    f2 = obj(x + 2*a*s);
    f3 = obj(x + 4*a*s);
    a = (f1*(4*a^2 - 16*a^2) + f2*(16*a^2 - a^2) + f3*(a^2 - 4*a^2))/ ...
        (2*(f1*(2*a - 4*a) + f2*(4*a - a) + f3*(a - 2*a)));
end

function [ a,C,Q ] = stepsize(x,s,a,obj,C,Q,g)
    global ls;

    if (ls == 1)
        % Quadratic line search it up in here
        a = linesearch(a,x,s,obj);
    elseif (ls == 2)
        % line search as in book (no iterations)
        a = exact_linsearch(x,s,a,obj);
    elseif (ls == 3)
        % iterative line search, works the best
        a = iter_linsearch(x,s,obj);
    elseif (ls == 4)
        [ a,~ ] = goldensection(x,s,obj);
    elseif (ls == 5)
        [ a ] = inexact(x,s,g,obj);
    end
end

function [ f ] = lookup(x,obj)
    global LUT keyfmt nobj_saved;
    
    key = char(sprintf(keyfmt,x));
    if LUT.isKey(key)
        %fprintf('Found the key!\n');
        nobj_saved = nobj_saved + 1;
        f = LUT(key);
    else
        %fprintf('No key...\n');
        f = obj(x);
        LUT(key) = f;
    end
end

function [ a_good ] = iter_linsearch(x0,s,obj)
    a0 = 1; % always start with a guess of 1
    
    f = [ lookup(x0,obj) lookup(x0 + a0*s,obj) ]; % initial conditions
    a = [ 0 a0 ];
    t = 1.2; % factor of increase, need not be 2
    n = numel(x0);
    
    tol = 1e-4;
    a_good = 1e6; a_test = 0;
    
    % Keep fitting the parabola till the change in the min is very small
    while (abs(a_good - a_test) > tol)
        a_test = a_good;
        
        while ((f(end) < f(end-1)) || (numel(unique(f)) < n+1))
            if (a(end) == 0)
                if a_good == 0
                    a(end) = 20*eps0;
                else
                    a(end) = a_good;
                end
            end
            
            if a(end) == Inf
                a(end) = 1;
            end
            
            a(end+1) = a(end)*t;
            f(end+1) = lookup(x0 + a(end)*s,obj);
        end

        % Go back and fill in
        a = [ a(1:end-1) (a(end)+a(end-1))/2 a(end) ];
        f = [ f(1:end-1) lookup(x0 + a(end-1)*s,obj) f(end) ];
        
        try
            % Assume quadratic
            a_good = (f(1)*(a(2)^2 - a(3)^2) + f(2)*(a(3)^2 - a(1)^2) + f(3)*(a(1)^2 - a(2)^2))/ ...
                (2*(f(1)*(a(2) - a(3)) + f(2)*(a(3) - a(1)) + f(3)*(a(1) - a(2))));
        catch
            fprintf('I didn''t have enough points to interpolate min!\n');
        end
        
        if (a_good < 0)
            [ ~,idx ] = sort(f,'ascend');
            if a(idx(1)) == 0
                a_good = 20*eps;
            else
                a_good = a(idx(1));
            end
        end
        
        f = [ lookup(x0 + a_good*s,obj) f ];
        a = [ a_good a ];
        
        [ f,idx ] = sort(f,'ascend');
        f = f(1:2);
        a = a(idx(1:2));
        
    end
    a_good = a(1);
end

function [ lambda_star, F_star ] = goldensection(x,s,obj)
    
    r = (sqrt(5) - 1)/2;
    tol = sqrt(eps);

    % Given interval [a,b]
    a = 0;
    b = 1;
    L0 = b - a;

    ii = 0;
    
    % (1)
    lambda1 = a + r^2*L0;
    lambda2 = a + r*L0;
    while 1
        % (2)
        F1 = obj(x + lambda1*s);
        F2 = obj(x + lambda2*s);
        ii = ii + 1;


        % (3)
        if F1 > F2
            a = lambda1;
            lambda1 = lambda2;
            Li = (b - a);
            lambda2 = a + r*Li;
        else
            b = lambda2;
            lambda2 = lambda1;
            Li = (b - a);
            lambda1 = a + r^2*Li;
        end

        % (4)
        if Li < tol
            lambda_star = (b + a)/2;
            F_star = obj(x + lambda_star*s);
            break;
        end
    end
end

function [ lambda_bar ] = inexact(x,s,g,obj)
    eps1 = 0.2;
    eps2 = 2;

    F0 = lookup(x,obj);
    lambda = 1;
    F = lookup(x + lambda*s,obj);
    
    % step 1
    if F <= (F0 + lambda*eps1*g.'*s)
        if lookup(x + eps2*lambda*s,obj) > (F0 + eps2*lambda*eps1*g.'*s)
            lambda_bar = lambda;
        else
            % step 3
            t = 0;
            while 1
                if (lookup(x + eps2^t*s,obj) > (F0 + eps2^t*eps1*g.'*s))
                    lambda_bar = eps2^(t-1);
                    break;
                end
                t = t + 1;
            end
        end
    else
        % step 2
        t = 2;
        while 1
            F = lookup(x + (1/eps2^t)*s,obj);
            if  (F <= (F0 + 1/eps2^t*eps1*g.'*s))
                lambda_bar = 1/(eps2^t);
                break;
            end
            t = t + 1;
        end
    end
end

function [ a ] = exact_linsearch(x0,s,a0,obj)
    
    f = [ obj(x0) obj(x0 + a0*s) ]; % initial conditions
    a = [ 0 a0 ];
    t = 1.3; % factor of increase
    
    n = numel(x0);
    
    while ((f(end) < f(end-1)) || (numel(unique(f)) < n))
        a(end+1) = a(end)*t;
        f(end+1) = obj(x0 + a(end)*s);
    end
    
    % Go back and fill in
    a = [ a(1:end-1) (a(end)+a(end-1))/2 a(end) ];
    f = [ f(1:end-1) obj(x0 + a(end-1)*s) f(end) ];
    
    % Get rid of duplicate values if we have any
    [ f,idx ] = unique(f,'stable');
    a = a(idx);
    
    %plot(a,f);
    
    % I see people switching between quadratic and cubic fits, but we'll
    % just assume a quadratic for ease
    try
         a = (f(1)*(a(2)^2 - a(3)^2) + f(2)*(a(3)^2 - a(1)^2) + f(3)*(a(1)^2 - a(2)^2))/ ...
                (2*(f(1)*(a(2) - a(3)) + f(2)*(a(3) - a(1)) + f(3)*(a(1) - a(2))));
    catch
        fprintf('caught one');
    end
end
function [ f ] = cobj(X,Y,Z)
    global testflag;
    
    if testflag == 1
        f = 20 + 3*X - 6*Y + 8*Z + 6*X.^2 - 2*X.*Y - X.*Z + Y.^2 + 0.5*Z.^2;
    elseif testflag == 2
        f = 100*(Y - X.^2).^2 + (1 - X).^2;
    elseif testflag == 3
        f = X.^2 - 2*X.*Y + 4*Y.^2;
    end
end