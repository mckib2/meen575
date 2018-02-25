function [  ] = optimize_spring()

    % ------------Starting point and bounds------------
    %      d    D    n     hf
    ub = [ .2,  3.2, +Inf, +Inf ]; % upper bound
    lb = [ .01, .04, 1,    1    ]; % lower bound

    % ------------Linear constraints------------
    A = [];
    b = [];
    Aeq = [];
    beq = [];

    % ------------Objective and Constraints------------
    function [f, c, ceq] = objcon(x)
        
        % design variables
%         d = x(1);  % wire diameter (in)
%         D = x(2);  % coil diameter (in)
%         n = x(3);  % number of coils
%         hf = x(4); % free height (in)

        % use valder objects
        d  = valder(x(1),[ 1 0 0 0 ]);
        D  = valder(x(2),[ 0 1 0 0 ]);
        n  = valder(x(3),[ 0 0 1 0 ]);
        hf = valder(x(4),[ 0 0 0 1 ]);
        
        % other analysis variables
        delta0 = 0.4;
        h0 = 1.0;
        Q = 15e4;
        G = 12e6;
        Se = 45e3;
        Sf = 1.5;
        w = 0.18;
        
        % analysis functions
        [ Sy,hs,k,K,m,tmax,tmin,tm,ta,hdef,t_hs,F ] = get_vals(Q,d,w,n,G,D,h0,hf,delta0);
        fcheck = [ F.val,Sy.val,hs.val,k.val,K.val,m.val,tmax.val,tmin.val,tm.val,ta.val ];
        
        % objective function
        %f = 1/F; % maximize force by minimizing 1/F
        f = -F;
        
        %inequality constraints (c<=0)
        c = zeros(7,1);         % create column vector
        c(1) = 4 - D.val/d.val;         % 4 <= D/d
        c(2) = D.val/d.val - 16;        % D/d <= 16
        c(3) = .05 - hdef + hs.val;     % hdef - hs > 0.05
        c(4) = ta.val - Se/Sf;          % ta <= Se/Sf
        c(5) = ta.val + tm.val - Sy.val/Sf; % ta + tm <= Sy/Sf
        c(6) = t_hs.val - Sy.val;       % t_hs < Sy
        c(7) = D.val + d.val - .75;     % D + d < .75
        
        
        %equality constraints (ceq=0)
        ceq = [ ];

        Fs = [ F.val  Sy.val  hs.val  k.val  K.val  m.val  tmax.val  tmin.val  tm.val  ta.val ].';
        J =  [ F.der; Sy.der; hs.der; k.der; K.der; m.der; tmax.der; tmin.der; tm.der; ta.der ];
        
        % do a simple forward difference rule to verify what we're getting
        % makes sense
        Jcheck = zeros(size(J));
        h = 1e-10;
        for ii = 1:numel(fcheck)
            for jj = 1:numel(x)
                xp = zeros(size(x)); xp(jj) = h;
                [ aSy,ahs,ak,aK,am,atmax,atmin,atm,ata,ahdef,~,aF ] = get_vals(Q,x(1)+xp(1),w,x(3)+xp(3),G,x(2)+xp(2),h0,x(4)+xp(4),delta0);
                dict = [ aF,aSy,ahs,ak,aK,am,atmax,atmin,atm,ata,ahdef ];
                forward = dict(ii);
                Jcheck(ii,jj) = (forward - fcheck(ii))/h;
            end
        end
        
        table0 = table(Fs,J,Jcheck,'RowNames',{ 'Force','Sy','hs','k','K','m','tmax','tmin','tm','ta' });
        
        disp(table0);
        
        disp(J-Jcheck);
        
    end

    function [ Sy,hs,k,K,m,tmax,tmin,tm,ta,hdef,t_hs,F ] = get_vals(Q,d,w,n,G,D,h0,hf,delta0)
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
    end


%     % ------------Call fmincon N times------------
%     x0 = zeros(N,4);
%     xopt = x0;
%     fopt = zeros(N,1);
%     for nn = 1:N
%         % Find a feasible starting point
%         [x00,~,~,~] = linprog(ones(1,4)/2,A,b,Aeq,beq,lb,ub);
%         x00 = x00.' + nn.*rand(1,4);
%         x0(nn,:) = x00;
%         
%         history.x = [];
%         history.fval = [];
%         options = optimoptions(@fmincon,'Display','none','MaxFunctionEvaluations',Inf,'MaxIterations',Inf,'Algorithm',algorithm);
%         [xopt(nn,:),fopt(nn,:),exitflag,~] = fmincon(@obj,x00,A,b,Aeq,beq,lb,ub,@con,options);
%         histories(nn) = history;
%     end

    % just run for the initial point
    x0 = [ .02 .5 7 1.2 ];
    objcon(x0);
    

        
    % ------------Separate obj/con (do not change)------------
    function stop = outfun(x,optimValues,state)
        stop = false;
        switch state
            case 'init'
                %hold on;
            case 'iter'
            % Concatenate current point and objective function
            % value with history. x must be a row vector.
              history.fval = [history.fval; optimValues.fval];
              history.x = [history.x; x];
            % Concatenate current search direction with 
            % searchdir.
              %searchdir = [searchdir;... 
              %             optimValues.searchdirection'];
              %plot(x(1),x(2),'o');
            % Label points with iteration number and add title.
            % Add .15 to x(1) to separate label from plotted 'o'
              %text(x(1)+.15,x(2),... 
              %     num2str(optimValues.iteration));
              %title('Sequence of Points Computed by fmincon');
            case 'done'
                %hold off;
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