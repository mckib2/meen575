clear;
close all;

% Objective function LUT
global LUT keyfmt nobj_saved;
LUT = containers.Map();
keyfmt = '%.53f %.53f %.53f';
nobj_saved = 0;

global nobj ngrad testflag ls;
nobj = 0;
ngrad = 0;

% 1 => quadratic line search (only fits 3 points)
% 2 => exact line search (as in book)
% 3 => iterative exact line search (best)
% 4 => nonmonotonic line search (inexact method)
% 5 => Golden section algorithm
% 6 => Powell's interpolation algorithm
% 7 => Inexact
ls = 3;

% 1 => quadratic
% 2 => rosenbrocks
% 3 => book example
testflag = 2;

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


[xopt,fopt,exitflag,h] = fminun(@obj,@grad,x0,stoptol,algoflag);
fprintf('Efficiency: %f\n',nobj + numel(x0)*ngrad);
disp(table(x0,xopt,grad(xopt)));
disp(table(fopt,exitflag,nobj,nobj_saved,ngrad));

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

%%
fprintf('We were actaully looking for...\n');
options = optimoptions('fminunc','Display','iter','Algorithm','quasi-newton','SpecifyObjectiveGradient',true,'StepTolerance',eps,'MaxFunctionEvaluations',500,'MaxIterations',Inf);
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
        [ a,C,Q ] = nonmonotone(s,g,x,obj,C,Q);
    elseif (ls == 5)
        [ a,~ ] = goldensection(x,s,obj);
    elseif (ls == 6)
        [ a ] = powell(x,s,obj);
    elseif (ls == 7)
        [ a ] = inexact(x,s,g,obj);
    end

end

function [ xopt,fopt,exitflag,h ] = fminun(obj,grad,x0,stoptol,algoflag)
    global nobj ls;
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
            C(1) = obj(x0);
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
            C(1) = obj(x0);
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
            C(1) = obj(x0);
        else
            C = [];
        end
        Q(2) = 1;
        
        % Find the search direction
        g = grad(x);
        N = eye(numel(x),numel(x)); % I
        s = -N*g;

        print_head();
        print_iter(iter,obj(x),0,norm(g,Inf));
        
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
            
            print_iter(iter,obj(xp),a,norm(gp,Inf));
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
end

function [ a ] = linesearch(a,x,s,obj)
    f1 = obj(x + a*s);
    f2 = obj(x + 2*a*s);
    f3 = obj(x + 4*a*s);
    a = (f1*(4*a^2 - 16*a^2) + f2*(16*a^2 - a^2) + f3*(a^2 - 4*a^2))/ ...
        (2*(f1*(2*a - 4*a) + f2*(4*a - a) + f3*(a - 2*a)));
end

%% Bracket out an interval of acceptable points, 2.6.2
function [a,b,alpha] = bracketing(alpha,x0,f0,g0,s,obj,grad)

    % Let's choose some values
    tau = 9; % typical value for  tau > 1
    sigma = 0.9; % 0.9 => weak line search, .1 => fairly accurate
    rho = 0.01; % is typical
    fbar = -1e6; % lower bound on f(alpha); 0 for nonlinear ls problem
    fprime0 = s.'*g0;
    mu = (fbar - f0)/(rho*fprime0);
    
    
    % Initial conditions
    fp = f0;
    %alphap = alpha;
    alphap = 0;
    alpha = 9;
    
    
    tflag = 0;
    % Start looping till we get an alpha or an iterval a,b
    while 1
        f = obj(x0 + alpha*s);
        
        if f <= fbar
            % terminate for good!
            tflag = 1;
            break;
        end
        
        if ((f > (f0 + alpha*fprime0)) || (f >= fp))
            a = alphap;
            b = alpha;
            % terminate
            break;
        end
        
        g = grad(x0 + alpha*s);
        fprime = s.'*g;
        if (abs(fprime) <= -sigma*fprime0)
            % terminate
            break;
        end
        
        if (fprime >= 0)
            a = alpha;
            b = alphap;
            % terminate
            break;
        end
        
        if (mu <= (2*alpha - alphap))
            alpha = mu;
        else            
            % Choose alpha to minimize in the given interval a cubic
            % polynomial interpolating f(alpha),grad(alpha),f(alphap), and
            % grad(alphap).
            ab = [ (2*alpha - alphap), min([ mu, (alpha + tau*(alpha - alphap)) ]) ];
            %cp = interp1([],
            
            % Well, since we can choose any way, I choose random for now
            %alpha = (ab(2) - ab(1)).*rand(1,1) + ab(1);
            %alpha = ab(end);
            ffit = interp1(ab,[obj(x0 + a*s),s.'*grad(x0 + a*s),obj(x0 + b*s),s.'*grad(x0 + b*s)].','poly3');
            xs = linspace(min(ab),max(ab),1000);
            val = polyval(ffit,xs);
            alpha = xs(find(min(val)));
        end
        
        alphap = alpha;
    end
   
    if tflag == 0
       % go to next stage
       alpha = NaN;
    else
        a = NaN;
        b = NaN;
    end
end

%% Sectioning to find acceptable point, 2.6.4
function [ alpha ] = get_alpha(alpha,x0,f0,g0,s,obj,grad)

    [ a,b,alpha_try] = bracketing(alpha,x0,f0,g0,s,obj,grad);

    if ~isnan(alpha_try)
        alpha = alpha_try;
        return;
    else
        alpha = 9;
    end
    
    % Set some parameters
    % 0 < tau2 < tau3 <= 1/2
    tau2 = 1/10; % typical, tau2 <= sigma is  advisable
    tau3 = 1/2; % algorithm is insensitive to tau2,tau3
    rho = 0.01;
    fprime0 = s.'*g0;
    sigma = 0.9;
    
    % Loop until we find acceptable alpha
    while 1
        
        % Sensible to minimize in the given interval a quadratic or cubic
        % polynomial which interpolates f(a),f'(a),f(b),f'(b) if known
        ab = [ (alpha + tau2*(b - a)), (b - tau3*(b - a)) ];
        %alpha = (ab(2) - ab(1)).*rand(1,1) + ab(1);
        %alpha = max(ab);
        ffit = interp1(ab,[obj(x0 + a*s),s.'*grad(x0 + a*s),obj(x0 + b*s),s.'*grad(x0 + b*s)].','poly3');
        xs = linspace(min(ab),max(ab),1000);
        val = polyval(ffit,xs);
        alpha = xs(find(min(val)));

        
        f = obj(x0 + alpha*s);
        fa = obj(x0 + a*s);
        
        if ((f > (f0 + rho*alpha*fprime0)) || (f >= fa))
            %a = a;
            b = alpha;
        else
            g = grad(x0 + alpha*s);
            fprime = s.'*g;
            
            if (abs(fprime) <= -sigma*fprime0)
                % terminate
                break;
            end
            
            ap = a;
            a = alpha;
            
            if ((b - a)*fprime >= 0)
                b = ap;
            else
                %b = b;
            end
        end
    end
end