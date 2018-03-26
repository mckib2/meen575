function [ df,dg,svars,l ] = getDers(f,gs)
% [ df,dg,svars,l ] = getDers(f,gs)
% Get gradients for objective and constraints.
% 
%    f  -- Symbolic objective function, in the form f(x1,x2,...).
%    gs -- Cell array of symbolic constraints, in the form
%          g(x1,x2,...) = 0 or g(x1,x2,...) >= 0.
%
%    df -- Cell array of symbolic objective gradients, i.e. df{i}: df/dxi.
%    dg -- Cell array of symbolic constraint gradients, i.e.
%          dg{i}{j}: dgj/xi.
%    svars -- Array of symbolic objective function arguments (x1,x2,...).
%    l  -- Array of symbolic lagrange multipliers for each constraint
%          gradient (l1,l2,...).

    % Create a vector of symbolic lambdas
    l = sym('l',[ 1 numel(gs) ]);
    
    % Grab all the x's (x1,x2,...) from original objective
    svars = symvar(f);
    
    % Initialize cell arrays
    x = cell(numel(svars),1);
    df = x;
    dg = cell(numel(svars),numel(gs));
    
    % Take the derivates everywhere we need them
    for ii = 1:numel(svars)
        % Discover our symbolic variable arg
        x{ii} = svars(ii);
    
        % Get derivatives
        df{ii}(svars) = diff(f,x{ii});
        
        % Get constraint gradient for each constraint at each xi
        for jj = 1:numel(gs)
            dg{ii}{jj}(svars,l) = diff(gs{jj},x{ii});
        end
    end
end