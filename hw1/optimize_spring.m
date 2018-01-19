function [x0,xopt,fopt,exitflag,histories] = optimize_spring(N,cfun,algorithm)

    % ------------Starting point and bounds------------
    %x0 = [ .05,.5,10,1.5 ]; % starting point
    %      d    D    n     hf
    ub = [ .2,  3.2, +Inf, +Inf ]; % upper bound
    lb = [ .01, .04, 1,    1 ]; % lower bound

    % ------------Linear constraints------------
    A = [];
    b = [];
    Aeq = [];
    beq = [];

    % ------------Objective and Constraints------------
    function [f, c, ceq] = objcon(x)
        
        % design variables
        d = x(1);  % wire diameter (in)
        D = x(2);  % coil diameter (in)
        n = x(3);  % number of coils
        hf = x(4); % free height (in)
        
        % other analysis variables
        delta0 = 0.4;
        h0 = 1.0;
        Q = 15e4;
        G = 12e6;
        Se = 45e3;
        Sf = 1.5;
        w = 0.18;
        
        % analysis functions
        Sy = 0.44*Q/d^w;
        hs = n*d;
        k = G*d^4/(8*D^3*n);
        K = (4*D - d)/(4*(D - d)) + 0.62*d/D;
        m = 8*K*D/(pi*d^3);
        tmax = (hf - h0 + delta0)*k*m;
        tmin = (hf - h0)*k*m;
        tm = (tmax + tmin)/2;
        ta = (tmax - tmin)/2;
        hdef = h0 - delta0;
        t_hs = (hf - hs)*k*m; % stress at solid height
        F = k*(hf - h0);

        % objective function
        %f = 1/F; % maximize force by minimizing 1/F
        f = cfun(F);
        
        %inequality constraints (c<=0)
        c = zeros(7,1);         % create column vector
        c(1) = 4 - D/d;         % 4 <= D/d
        c(2) = D/d - 16;        % D/d <= 16
        c(3) = .05 - hdef + hs; % hdef - hs > 0.05
        c(4) = ta - Se/Sf;      % ta <= Se/Sf
        c(5) = ta + tm - Sy/Sf; % ta + tm <= Sy/Sf
        c(6) = t_hs - Sy;       % t_hs < Sy
        c(7) = D + d - .75;     % D + d < .75
        
        %equality constraints (ceq=0)
        ceq = [];

    end


    % ------------Call fmincon N times------------
    x0 = zeros(N,4);
    xopt = x0;
    fopt = zeros(N,1);
    for nn = 1:N
        % Find a feasible starting point
        [x00,~,~,~] = linprog(ones(1,4)/2,A,b,Aeq,beq,lb,ub);
        x00 = x00.' + nn.*rand(1,4);
        x0(nn,:) = x00;
        
        history.x = [];
        history.fval = [];
        options = optimoptions(@fmincon,'OutputFcn',@outfun,'MaxFunctionEvaluations',Inf,'MaxIterations',Inf,'Algorithm',algorithm);
        [xopt(nn,:),fopt(nn,:),exitflag,~] = fmincon(@obj,x00,A,b,Aeq,beq,lb,ub,@con,options);
        histories(nn) = history;
    end
        
    % ------------Separate obj/con (do not change)------------
    function stop = outfun(x,optimValues,state)
        stop = false;
        switch state
            case 'init'
                hold on;
            case 'iter'
            % Concatenate current point and objective function
            % value with history. x must be a row vector.
              history.fval = [history.fval; optimValues.fval];
              history.x = [history.x; x];
            % Concatenate current search direction with 
            % searchdir.
              %searchdir = [searchdir;... 
              %             optimValues.searchdirection'];
              plot(x(1),x(2),'o');
            % Label points with iteration number and add title.
            % Add .15 to x(1) to separate label from plotted 'o'
              text(x(1)+.15,x(2),... 
                   num2str(optimValues.iteration));
              title('Sequence of Points Computed by fmincon');
            case 'done'
                hold off;
            otherwise
         end
     end
    
    function [f] = obj(x) 
        [f, ~, ~] = objcon(x);
    end
    function [c, ceq] = con(x) 
        [~, c, ceq] = objcon(x);
    end
end