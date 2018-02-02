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
    
    % I see people switching between quadratic and cubic fits, so I will,
    % too
    try
        if (n <= 2)
            % Assume quadratic
            a = (f(1)*(a(2)^2 - a(3)^2) + f(2)*(a(3)^2 - a(1)^2) + f(3)*(a(1)^2 - a(2)^2))/ ...
                (2*(f(1)*(a(2) - a(3)) + f(2)*(a(3) - a(1)) + f(3)*(a(1) - a(2))));
        else
            % Use a cubic fit
            cfun = fit(a.',f.','poly3');
            
            xs = linspace(0+20*eps,2,1e7);
            [ ~,idx ] = min(cfun(xs));
            a = xs(idx);
        end
    catch
        fprintf('caught one');
    end
end