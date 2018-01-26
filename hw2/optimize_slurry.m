function [ xopt, fopt, Ptot, exitflag, output ] = optimize_slurry(useFit,show,x0)

    % ------------Starting point and bounds------------
    if nargin < 3
        %      V     D         d
        x0 = [ 10    0.0006       0.0006 ];
    end
    ub = [ +Inf  0.5       .01 ];
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
        [L,W,a,V,c,D,d,Qw,rho,Pg,fr,fw,g,rhow,Cd,S,Rw,mu,gamma,delp,gc,Q,Pf,Vc] = getvals(V,D,d,useFit,show);

        % Objective Function
        % For now, let's just look at minimizing total power
        %f = Pg + Pf;
        Ptot = Pg + Pf;
        
        % Now consider cost        
        f = cost(Pg,Pf);
        
        % set objective/constraints here (c <= 0)
        con = zeros(2,1);
        con(1) = c - 0.4; % c < 0.4
        con(2) = -V + Vc*1.1; % 1.1*Vc < V
        
        ceq = [];
        %ceq = zeros(1,1);
        %ceq(1) = V - Vc*1.1; % V = 1.1*Vc
    end

    % ------------Call fmincon------------
    options = optimoptions(@fmincon,'display','none','StepTolerance',1e-16,'Algorithm','sqp','MaxFunctionEvaluations',Inf);
    [xopt, fopt, exitflag, output] = fmincon(@obj, x0, A, b, Aeq, beq, lb, ub, @con, options);
    
    % ------------Separate obj/con (do not change)------------
    function [f] = obj(x)
            [f, ~, ~] = objcon(x);
    end
    function [c, ceq] = con(x)
            [~, c, ceq] = objcon(x);
    end
end