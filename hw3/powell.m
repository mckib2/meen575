%% Powell's interpolation algorithm

function [ lambda_star ] = powell(x,s,obj)

    h = 0.1;
    H = 2;
    tol = sqrt(eps);

    lambdas = [ ];
    F = [ ];
    
    % (1)
    lambdas(1) = 1;
    F(1) = obj(x + lambdas(1)*s);
    lambdas(2) = lambdas(1) + h;
    F(2) = obj(x + lambdas(2)*s);
    
    % (2)
    if F(1) < F(2)
        lambdas(3) = lambdas(1) - h;
        F(3) = obj(x + lambdas(3)*s);
    else
        lambdas(3) = lambdas(1) + 2*h;
        F(3) = obj(x + lambdas(3)*s);
    end
    
    while 1
        % (3)
        F012 = F(1)/((lambdas(1) - lambdas(2))*(lambdas(1) - lambdas(3))) + F(2)/((lambdas(2) - lambdas(1))*(lambdas(2) - lambdas(3))) + F(3)/((lambdas(3) - lambdas(1))*(lambdas(3) - lambdas(2)));
        F01 = F(1)/(lambdas(1) - lambdas(2)) + F(2)/(lambdas(2) - lambdas(1));

        lambdam = (F012*(lambdas(1) + lambdas(2)) - F01)/(2*F012);

        % find closest point to lambdam - lambdan
        [ ~,idx_min ] = min(lambdas - lambdam);
        lambdan = lambdas(idx_min);
        
        if (F012 > 0) && (abs(lambdam - lambdan) > H)
            % min point
            % remove furthest point from lambdam - lambdaf
            [ ~,idx ] = max(lambdas - lambdam);
            lambdas(idx) = [];
            F(idx) = [];

            % take step of size H from the point with the lowest value
            [ ~,idx ] = min(F);
            x = x + H*s;
            lambdas(end+1) = 0;
            F(end+1) = obj(x + lambdas(end)*s);
        elseif (F012 <= 0)
            % max point
            % remove point closest to lambdam
            lambdas(idx_min) = [];
            F(idx) = [];
            
            % Take step of size H from point with lowest value
            [ ~,idx ] = min(F);
            
            x = x + H*s;
            lambdas(end+1) = 0;
            F(end+1) = obj(x + lambdas(end)*s);
        else
            % (5)
            if abs(lambdam - lambdan) < tol
                lambda_star = min(lambdam,lambdan);
                break;
            else
                % discard point with highest F value and replace with
                % lambdam
                [ ~,idx ] = max(F);
                lambdas(idx) = lambdam;
            end
        end
    end
end