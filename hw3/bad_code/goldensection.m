%% Basic Golden section  algorithm

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