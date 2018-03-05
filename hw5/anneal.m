function [ xopt,fopt,h,nobj ] = anneal(obj,x0,Ps,Pf,N,n,sigma)

    % Loop params
    Ts = -1/log(Ps);
    Tf = -1/log(Pf);
    F = (Tf/Ts)^(1/(N - 1));
    rng('default');
    
    % Set initial values
    x1 = x0(1);
    x2 = x0(2);
    f = obj(x1,x2);
    T = Ts;
    dEavg = f;
    nobj = 0;
    
    % Update the history
    h.x(1,:) = [ x1 x2 ];
    h.f(1) = f;
    
    idx = 2;
    while T > Tf
        for ii = 1:n
            % Randomly perturb the design to different discrete values
            % close to the current design
            x11 = x1 + (2*rand(1) - 1)*sigma;
            x22 = x2 + (2*rand(1) - 1)*sigma;

            % Try it out
            ff = obj(x11,x22);
            nobj = nobj + 1;
            
            % Grab some values for Pb
            dE = abs(ff - f);

            % If the new design is better, accept it as the current design
            if ff < f
                f = ff; % Accept the design!
                x1 = x11;
                x2 = x22;
                dEavg = (dEavg*(ii-1) + dE)/ii; % add to the running avg
            else
                % If the new design is worse, generate a random number
                % between 0 and 1 using a uniform distribution. Compare
                % this number to the Boltzmann probability. If the random
                % number is lower than the Boltzmann probability, accept
                % the worse design as the current design

                rnum = rand(1);
                Pb = exp(-dE/(dEavg*T));

                if rnum < Pb
                    % Accept!
                    x1 = x11;
                    x2 = x22;
                    f = ff;
                    dEavg = (dEavg*(ii-1) + dE)/ii;
                end
            end

            % Update the history
            h.x(idx,:) = [ x1 x2 ];
            h.f(idx) = f;
            idx = idx + 1;
        end
        
        % Decrease Temperature
        T = F*T;
    end
    
    % Assign resulting values as the optimum
    xopt = [ x1 x2 ];
    fopt = f;
end