function [ r ] = getRows(gs,df,dg,svars,l)
% [ r ] = getRows(gs,df,dg,svars,l)
% Get rows of A where A is the matrix of coefficients used in solving the
% matrix form of the KKT equations, i.e. A*[ x1; x2; ... l1; l2; ... ] = b.
%
%    gs -- Cell array of binding symbolic constraint gradients in the form
%          given by getDers().
%    df -- Cell array of symbolic objective gradients in the form given by
%          getDers().
%    svars -- Array of symbolic objective function arguments (x1,x2,...).
%    l  -- Array of symbolic lagrange multipliers for each constraint
%          gradient (l1,l2,...).
%
%    r  -- Cell array of symbolic coefficients for each row of A, i.e.
%          A = [ r1; r2; ... ].

    % Initialize cell array
    r = cell(1,numel(svars)+numel(gs));
    
    for ii = 1:numel(svars)
        % Start the row with the gradient of the corresponding objective
        r{ii}(svars,l) = df{ii};
        
        % Now add in all constraint gradients along with lagrange
        % multiplier.
        for jj = 1:numel(gs)
            r{ii}(svars,l) = r{ii} - l(jj)*dg{ii}{jj};
        end
    end
    
    % The last rows are the constraint gradients
    for jj = 1:numel(gs)
        r{numel(svars)+jj}(svars,l) = gs{jj};
    end
end