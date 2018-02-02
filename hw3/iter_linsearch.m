function [ a_good ] = iter_linsearch(x0,s,obj)
    a0 = 1; % always start with a guess of 1

    f = [ obj(x0) obj(x0 + a0*s) ]; % initial conditions
    a = [ 0 a0 ];
    t = 1.2; % factor of increase, need not be 2
    n = numel(x0);
    
    tol = 1e-10;
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
                fprintf('alpha was Inf! Changed to 1...\n');
                a(end) = 1;
            end
            
            a(end+1) = a(end)*t;
            f(end+1) = obj(x0 + a(end)*s);
        end

        % Go back and fill in
        a = [ a(1:end-1) (a(end)+a(end-1))/2 a(end) ];
        f = [ f(1:end-1) obj(x0 + a(end-1)*s) f(end) ];

        % Get rid of duplicate values if we have any
        %[ f,idx ] = unique(f,'stable');
        %a = a(idx);

        try
            % Assume quadratic
            a_good = (f(1)*(a(2)^2 - a(3)^2) + f(2)*(a(3)^2 - a(1)^2) + f(3)*(a(1)^2 - a(2)^2))/ ...
                (2*(f(1)*(a(2) - a(3)) + f(2)*(a(3) - a(1)) + f(3)*(a(1) - a(2))));
        catch
            fprintf('I didn''t have enough points to interpolate min!\n');
        end
        
        if (a_good < 0)
            %a_good = a_test;
            %break;
            fprintf('alpha is negative! Changing to reasonable value...\n');
            
            % Try fitting a cubic?
            %cfun = fit(a.',f.','poly3');
            
            %xs = linspace(0+20*eps,1,1e7);
            %[ ~,idx ] = min(cfun(xs));
            %a_good = xs(idx);
            
            [ ~,idx ] = sort(f,'ascend');
            if a(idx(1)) == 0
                a_good = 20*eps;
            else
                a_good = a(idx(1));
            end
        end
        
        f = [ obj(x0 + a_good*s) f ];
        a = [ a_good a ];
        
        [ f,idx ] = sort(f,'ascend');
        f = f(1:2);
        a = a(idx(1:2));
        
    end
    
    a_good = a(1);
end