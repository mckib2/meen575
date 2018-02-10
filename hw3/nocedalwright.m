function [ alpha ] = nocedalwright(alpha,x0,s,g0,obj,grad)
    f0 = obj(x0);
    f = f0;
    g = g0;
    
    c1 = 1e-4;
    rhohi = 1/2;
    rholo = .1;
    maxstep = Inf;
    
    n = numel(x0);
    
    alphas = [alpha];
    fs = [f];
    
    iterfinitemax = 1000;
    iterfinite = 0;
    while (~isfinite(f) && (iterfinite < iterfinitemax))
        iterfinite = iterfinite + 1;
        alpha = alpha*0.5;
        alphas = [ alphas alpha ];
        f = obj(x0 + alpha*s);
        fs = [ fs f ];
    end
    
    iteration = 0;
    while (f > (f0 + c1*alpha*s.'*g))
        iteration = iteration + 1;
        if ((n == 2) || iteration == 1)
            alphatmp = -(s.'*g * alpha^2) / (2*(f - f0 - (s.'*g)*alpha));
        else
            alpha0 = alphas(end-1);
            alpha1 = alphas(end);
            phi0 = fs(end-1);
            phi1 = fs(end);
            
            div = one(alpha) / (alpha0^2 * alpha1^2 * (alpha1 - alpha0));
            a = (alpha0^2*(phi1-f0-s.'*g*alpha1)-alpha1^2*(phi0-f0-s.'*g*alpha0))*div;
            b = (-alpha0^3*(phi1-f0-s.'*g*alpha1)+alpha1^3*(phi0-f0-s.'*g*alpha0))*div;
            
            if (a == 0)
                alphatmp = s.'*g / (2.0*b);
            else
                discr = max(b^2-3*a*s.'*g, zero(alpha));
                alphatmp = (-b + sqrt(discr)) / (3.0*a);
            end
        end
            
        alphatmp = min(alphatmp, alpha*rhohi);
        alphatmp = max(alphatmp, alpha*rholo);

        alpha = min(alphatmp, maxstep / norm(s, Inf));
        alphas = [ alphas alpha ];

        f = obj(x0 + alpha*s);
        fs = [ fs f ];
        g = grad(x0 + alpha*s);
    end
end