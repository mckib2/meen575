% function [xopt, fopt, exitflag, output] = optimize_template()

    % ------------Starting point and bounds------------
    x0 = [  ];
    ub = [  ];
    lb = [  ];

    % ------------Linear constraints------------
    A = [];
    b = [];
    Aeq = [];
    beq = [];

    % ------------Call fmincon------------
    options = optimoptions(@fmincon, 'display', 'iter-detailed');
    [xopt,fopt,exitflag,output] = fmincon(@obj,x0,A,b,Aeq,beq,lb,ub,@con,options);
    
    
    % ------------Separate obj/con (do not change)------------
    function [ f ] = obj(x)
            % objective to be minimized
    end
    function [ c,ceq ] = con(x)
            [ ~,c,ceq ] = objcon(x);
    end
    
        % ------------Objective and Non-linear Constraints------------
    function [ f,c,ceq ] = objcon(x)
        
        % set objective/constraints here, c <= 0
        c(1) = [];

        ceq = [];
        
    end
% end