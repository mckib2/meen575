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

global gflag;
% Tell me what kind of gradients you want:
%     0 => MATLAB's forward difference
%     1 => MATLAB's central difference
%     2 => Forward Difference
%     3 => Central Difference
%     4 => Complex Step
gflag = 4;

% Keep track of how many function calls we make.
global nfun hg hc;

% ------------Linear constraints------------
A = [];
b = [];
Aeq = [];
beq = [];

% ------------Call fmincon------------

options = optimoptions(@fmincon, ...
    'algorithm','interior-point', ...
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
    % CheckGradients on all custom rules 
    options.CheckGradients = true;
    fprintf('Setting CheckGradients to true!\n');
end

% We want to compare error characteristics
if ismember(gflag,[ 0 1 4 ])
    % we can be as small as we want with complex step and still have good
    % error characteristics
    hg = eps;
    hc = eps;
    gcp = get_g(4,x0,@obj,hg);
elseif ismember(gflag,[ 2 3 ])
    % run the thing for complex step to get our "golden" standard
    c = zeros(10,1);
    hg = eps;
    hc = eps;
    gcp = get_g(4,x0,@obj,hg);
    dccp = get_g(4,x0,@dc,hc,c);

    % find the gradient using the chosen method
    
    % Optimize to find them
    % hg = fmincon(@(x) max(get_g(gflag,x0,@obj,x) - get_g(4,x0,@obj,x)),100,[],[],[],[],0,Inf);
    % hc = fmincon(@(x) max(max(get_g(gflag,x0,@dc,x,c) - get_g(4,x0,@dc,x,c))),1e-4,[],[],[],[],0,Inf);
    
    % NOTE: fmincon's gradients seems to erratic, always giving different
    % values.  Haven't found a great way to counteract that yet...
    
    if gflag == 2
        hg = [];
        hc = 1.566654630266416e-06; % still doesn't pass gradient checks
    elseif gflag == 3
        hg = [];
        hc = []; % default usually works better than optimized...
        % hc = 9.999462011803676e-06;
    end
end

if gflag == 4
    gsamp = gcp;
end

options.Display = 'none';
try
    nfun = 0;
    tic;
    [ xopt,fopt,exitflag,output,~,g ] = fmincon(@obj,x0,A,b,Aeq,beq,lb,ub,@con,options);
    eltime = toc;
    
    % do some error checking
    if ~exitflag
        fprintf('Exit with error code %d!\n',exitflag);
    end

    % grab the constraints at the optimum
    [ c,~,dc_opt ] = con(xopt);

    % show some results in a table
    disp(table(x0(:),xopt(:),g(:),c(:),'VariableNames',{ 'x0','xopt','grad','c' }));
    % disp(table(dc_opt(:,1:5)));
    fprintf('f at xopt: %f\n',fopt); % objective function value at the minumum

    % tell us how many times we needed to call the cost function and runtime
    fprintf('nfun: %d\n',nfun);
    fprintf('Took %f s to run\n',eltime);

    if exist('gsamp','var')
        fprintf('Maximum relative difference between supplied\n');
        fprintf('and complex step derivates = %g\n',max(abs(gsamp - gcp)));
    else
        fprintf('Maximum relative difference between supplied\n');
        fprintf('and complex step derivates = %g\n',max(abs(g.' - gcp)));
    end
catch
    fprintf('FAILED! Seems as though our gradient checks have failed.\n');
end



% ------------Objective and Non-linear Constraints------------
function [ f,c,ceq,g,DC ] = objcon(x)
    global nfun gflag hg hc;

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
        g = get_g(gflag,x,@obj,hg);
    elseif nargout == 5
        % give back gradient of constraints if we asked for them
        DC = get_g(gflag,x,@dc,hc,c);
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
