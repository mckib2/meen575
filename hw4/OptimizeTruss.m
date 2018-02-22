%% Homework 4 - Computing Derivatives
% Nicholas McKibben
% MEEn 575
% 2018-02-21

clear;
close all;

% ------------Starting point and bounds------------
%design variables
x0 = ones(1,10)*5; % starting point (all areas = 5 in^2)
lb = ones(1,10)*.1; % lower bound
ub = ones(1,10)*20; % upper bound

% Tell me what kind of gradients you want:
%     0 => MATLAB's forward difference
%     1 => MATLAB's central difference
%     2 => Forward Difference
%     3 => Central Difference
%     4 => Complex Step
global gflag;
gflag = 4;

% Keep track of how many function calls we make.
global nfun;
nfun = 0;

% ------------Linear constraints------------
A = [];
b = [];
Aeq = [];
beq = [];

% ------------Call fmincon------------
tic;
options = optimoptions(@fmincon, ...
    'display','iter-detailed', ...
    'Diagnostics','on');

% Tell the optimizer how to get gradients based on gflag
% gflag == 0 => default MATLAB forward difference rule, no need to change
if ismember(gflag,[ 1 2 3 4 ])
    % MATLAB's Central Difference Rule
    % All other custom gradients also need this
    options.FiniteDifferenceType = 'central';
    fprintf('Setting FiniteDifferenceType to Central!\n');
end
if ismember(gflag,[ 2 3 4 ])
    % Custom gradient option
    options.SpecifyObjectiveGradient = true;
    fprintf('Setting SpecifyObjectiveGradient to true!\n');
    
%     options.SpecifyConstraintGradient = true;
%     fprintf('Setting SpecifyConstraintGradient to true!\n');
    
    options.CheckGradients = true;
    fprintf('Setting CheckGradients to true!\n');
end

[xopt,fopt,exitflag,output] = fmincon(@obj,x0,A,b,Aeq,beq,lb,ub,@con,options);  
eltime = toc;
fprintf('Took %f s to run\n',eltime);

% do some error checking
if ~exitflag
    fprintf('Exit with error code %d!\n',exitflag);
end

% grab the constraints at the optimum
[~,c,~] = objcon(xopt);

% show some results in a table
disp(table(x0.',xopt.',c)); % design variables at start and minimum, and c
fprintf('f at xopt: %f\n',fopt); % objective function value at the minumum

% tell us how many times we needed to call the cost function
fprintf('nfun: %d\n',nfun);

% ------------Objective and Non-linear Constraints------------
function [ f,c,ceq,g ] = objcon(x)
    global nfun gflag;

    %get data for truss from Data.m file
    Data;

    % insert areas (design variables) into correct matrix
    for ii = 1:nelem
        Elem(ii,3) = x(ii);
    end

    % call Truss to get weight and stresses
    [weight,stress] = Truss(ndof,nbc,nelem,E,dens,Node,force,bc,Elem);

    % objective function
    f = weight; % minimize weight

    % inequality constraints, c <= 0
    c = zeros(10,1);
    idx = 1;
    for ii = 1:10
        % check stress both pos and neg - could be complex
        if stress(ii) >= 0
            c(idx) = stress(ii) - 25e3;
        else
            c(idx) = -25e3 - stress(ii);
        end
        idx = idx + 1;
    end

%     % original constraints
%     c = zeros(10,1);
%     for ii = 1:10
%         c(ii) = abs(stress(ii)) - 25e3;
%     end

    % equality constraints, ceq = 0
    ceq = [];
    nfun = nfun + 1;
    
    % give back gradients if we asked for them
    if nargout > 3
        g = get_g(gflag,x,@obj,[]);
    end

end

% ------------Separate obj/con (do not change)------------
function [ f,g ] = obj(x)
    if nargout > 1
        [ f,~,~,g ] = objcon(x);
    else
        [ f ] = objcon(x);
    end
end
function [ c,ceq,DC,DCeq ] = con(x)
    if nargout > 2
        [ ~,c,ceq ] = objcon(x);
    else
        [ ~,c,ceq ] = objcon(x);
        DCeq = [];
%         DC = 
    end
end