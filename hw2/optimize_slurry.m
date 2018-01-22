function [ xopt, fopt, Ptot, exitflag, output ] = optimize_slurry()

    % ------------Starting point and bounds------------
    %      V     D         d
    x0 = [ 5     0.2       0.001 ];
    ub = [ +Inf  0.5       0.001 ];
    lb = [ 0     0.0005    0.0005 ];

    % ------------Linear constraints------------
    A = [];
    b = [];
    Aeq = [];
    beq = [];

    % ------------Objective and Non-linear Constraints------------
    function [f, con, ceq] = objcon(x)
        
        % Design Variables
        V = x(1);
        D = x(2);
        d = x(3);
        
        % Get the rest of the variables
        [L,W,a,V,c,D,d,Qw,rho,Pg,fr,fw,g,rhow,Cd,S,Rw,mu,gamma,delp,gc,Q,Pf,Vc] = getvals(V,D,d,0,0);

        % Objective Function
        % For now, let's just look at minimizing total power
        %f = Pg + Pf;
        Ptot = Pg + Pf;
        
        % Now consider cost        
        f = cost(Pg,Pf);
        
        % set objective/constraints here (c <= 0)
        con = zeros(3,1);
        con(1) = V - Vc*1.1; % V < Vc*1.1
        con(2) = d - a; % d < a
        con(3) = 2*d - D; % 2*d < D
        
        ceq = [];
    end

    % ------------Call fmincon------------
    options = optimoptions(@fmincon,'display','iter-detailed','StepTolerance',1e-16,'Algorithm','sqp','MaxFunctionEvaluations',Inf);
    [xopt, fopt, exitflag, output] = fmincon(@obj, x0, A, b, Aeq, beq, lb, ub, @con, options);
    
    % ------------Separate obj/con (do not change)------------
    function [f] = obj(x)
            [f, ~, ~] = objcon(x);
    end
    function [c, ceq] = con(x)
            [~, c, ceq] = objcon(x);
    end
end