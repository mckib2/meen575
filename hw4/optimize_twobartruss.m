function [xopt, fopt, exitflag, output] = optimize_twobartruss()


    % ------------Starting point and bounds------------
    %var= H  d   %design variables
    x0 = [ 10 3 ]; %starting point
    ub = [50, 5]; %upper bound
    lb = [5,  1]; %lower bound

    % ------------Linear constraints------------
    A = [];
    b = [];
    Aeq = [];
    beq = [];

    % ------------Objective and Non-linear Constraints------------
    function [f, c, ceq] = objcon(x)
        
        %design variables
%         H = x(1);  %height (in)
%         d = x(2);  %diameter (in)
        
        % use valder objects
        H = valder(x(1),[ 1 0 ]);
        d = valder(x(2),[ 0 1 ]);
        
        %other analysis variables
        P = 66;    %load (lbs)
        E = 30000; %modulus of elasticity (lbs/in)
        rho = 0.3; %density (lbs/in^3)
        t = .15;   %thickness (in)
        B = 60;    %separation distance (in)
        
        %analysis functions
        weight = rho*2*pi*d*t*sqrt((B/2)^2+H^2); %lbs
        stress = (P*sqrt((B/2)^2+H^2))/(2*t*pi*d*H); %ksi
        bstress = (pi^2*E*(d^2+t^2))/(8*((B/2)^2+H^2)); %ksi
        deflection = P*((B/2)^2+H^2)^(3/2)/(2*t*pi*d*H^2*E); %in

        %objective function
        f = weight; %minimize weight
        
        %inequality constraints (c<=0)
        c = zeros(3,1);         % create column vector
        c(1) = stress.val - 100;      %stress <= 100ksi
        c(2) = stress.val - bstress.val;  %stress-bstress <= 0
        c(3) = deflection.val - .25;  %deflection <= 0.25
        
        %equality constraints (ceq=0)
        ceq = [];
        
        F = [ weight.val stress.val bstress.val deflection.val ];
        J = [ weight.der; stress.der; bstress.der; deflection.der ];
        
        disp(table(F));
        disp(table(J));
    end


%     % ------------Call fmincon------------
%     options = optimoptions(@fmincon,'display','iter-detailed','Diagnostics','on');
%     [xopt, fopt, exitflag, output] = fmincon(@obj, x0, A, b, Aeq, beq, lb, ub, @con, options);
%     xopt %design variables at the minimum
%     fopt %objective function value at the minumum  fopt = f(xopt)

objcon(x0);


    % ------------Separate obj/con (do not change)------------
    function [f] = obj(x) 
        [f, ~, ~] = objcon(x);
    end
    function [c, ceq] = con(x) 
        [~, c, ceq] = objcon(x);
    end
end