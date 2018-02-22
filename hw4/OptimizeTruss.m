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
    'algorithm','sqp', ...
    'display','iter-detailed', ...
    'Diagnostics','on');

% Tell the optimizer how to get gradients based on gflag
% gflag == 0 => default MATLAB forward difference rule, no need to change
if ismember(gflag,[ 1 2 3 4 ])
    % Use MATLAB's Central Difference Rule. All other custom gradients
    % will use this.
    options.FiniteDifferenceType = 'central';
    fprintf('Setting FiniteDifferenceType to Central!\n');
end
if ismember(gflag,[ 2 3 4 ])
    % Custom gradient option
    options.SpecifyObjectiveGradient = true;
    fprintf('Setting SpecifyObjectiveGradient to true!\n');
    
    options.SpecifyConstraintGradient = true;
    fprintf('Setting SpecifyConstraintGradient to true!\n');
end
if ismember(gflag,[ 3 4 ])
    % CheckGradients on all custom rules except forward difference which is
    % not accurate enough to run with this option.
    options.CheckGradients = true;
    fprintf('Setting CheckGradients to true!\n');
end

[xopt,fopt,exitflag,output,~,g] = fmincon(@obj,x0,A,b,Aeq,beq,lb,ub,@con,options);  
eltime = toc;

% do some error checking
if ~exitflag
    fprintf('Exit with error code %d!\n',exitflag);
end

% grab the constraints at the optimum
[ c,~,dc_opt ] = con(xopt);

% show some results in a table
disp(table(x0.',xopt.',g.',c,'VariableNames',{ 'x0','xopt','grad','c' }));
% disp(table(dc_opt(:,1:5)));
fprintf('f at xopt: %f\n',fopt); % objective function value at the minumum

% tell us how many times we needed to call the cost function and runtime
fprintf('nfun: %d\n',nfun);
fprintf('Took %f s to run\n',eltime);

% ------------Objective and Non-linear Constraints------------
function [ f,c,ceq,g,DC ] = objcon(x)
    global nfun gflag;

    % get data for truss from Data.m file
    Data;
    Elem(:,3) = x; % insert areas (design variables) into correct matrix

    % call Truss to get weight and stresses
    [weight,stress] = Truss(ndof,nbc,nelem,E,dens,Node,force,bc,Elem);

    % objective function - minimize weight
    f = weight;

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

    % equality constraints, ceq = 0
    ceq = [];
    nfun = nfun + 1;
    
    if nargout == 4
        % give back gradient of objective if we asked for it
        g = get_g(gflag,x,@obj,[]);
    elseif nargout == 5
        % give back gradient of constraints if we asked for them
        DC = get_g(gflag,x,@dc,[],c);
        g = [];
    end

end

function [ c ] = dc(x)
    [ ~,c ] = objcon(x);
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
        DCeq = [];
        [ ~,c,ceq,~,DC ] = objcon(x);
    else
        [ ~,c,ceq ] = objcon(x);
    end
end
