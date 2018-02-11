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