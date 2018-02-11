 function [xopt,fopt,exitflag] = fminun(obj,gradobj,x0,stoptol,algoflag)

    % get function and gradient at starting point
    %[n,~] = size(x0); % get number of variables
    f = obj(x0);
    grad = gradobj(x0);
    grad_prev = [];
    s = [];
    x = x0;

    % set starting step length
    alpha = 0.5;
    tau = 0.5;
    beta = 0.1;
    
    count = 0;
    countlim = 1e6;
    
    x0 = [1; x0];
    A = 2*[ 0  0    0   0;
            0  6   -1  -1/2;
            0 -1    1   0;
            0 -1/2  0   1/2; ];
    B = -[ 20 3 -6 8 ].';
    r = B - A*x0;
    p = r;
    x = x0;
    
    while (count < countlim)

        alpha = r.'*r/(p.'*A*p);
        xn = x + alpha*p;
        xn(1) = 1; % we must hold x(1) at 1 (constant)
        rn = r - alpha*A*p;
        rn(1) = 0;
        
        if (norm(rn) < stoptol)
            x = xn;
            break;
        end
        
        beta = rn.'*rn/(r.'*r);
        pn = rn + beta*p;
        
        x = xn;
        r = rn;
        p = pn;
    end
    
    xopt = x(2:end);
    fopt = obj(x);
    exitflag = 0;
        
%         % update search direction
%         s_prev = s;
%         s = get_s(algoflag,grad,grad_prev,s_prev,count);
% 
%         % take a step
%         x = x + alpha*s;
%         f = obj(x);
%         
%         % Update gradient
%         grad_prev = grad;
%         grad = gradobj(x);
%         
%         % update alpha
%         alpha = get_alpha(alpha,tau,beta,f,x,obj,s,grad);
%         
%         % Make sure we don't get stuck for too long
%         count = count + 1;
%     end
%     
%     if (count >= countlim)
%         fprintf('Exceeded iteration count of  %d!\n',countlim);
%         exitflag = 1;
%     else
%         exitflag = 0;
%     end
%     
%     xopt = x;
%     fopt = f;
 end

 % get steepest descent search direction as a column vector
 function [ s ] = get_s(algoflag,grad,grad_prev,s_prev,count)
 
    if ((algoflag == 1) || (algoflag == 2 && ~count)) % steepest descent
       s = -grad;%/norm(grad);
    elseif (algoflag == 2) % CG
        beta = dot(grad,grad)/dot(grad_prev,grad_prev);
        s = -grad + beta*s_prev;
    else % BFGS
    
    end   
 end
 
 % Get next step using Backtracking-Armijo Line Search
 function [ alpha ] = get_alpha(alpha,tau,beta,f,x,obj,s,g)
    %promised = beta*dot(g,s);

    %f_comp = obj(x + alpha*s);
    %f_promised = f + promised;
    %while (f_comp > f_promised)
    %    alpha = tau*alpha;
    %    f_comp = obj(x + alpha*s);
    %    f_promised = f + alpha*promised;
    %end
    
    
    
 end