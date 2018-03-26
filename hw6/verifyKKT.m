function [ el,lambdas ] = verifyKKT(f,gs,xstar)
    [ df,dg,svars,l ] = getDers(f,gs);

    % Construct lagrange multiplier equations
    % These are the first numel(x) rows of r.
    [ r ] = getRows(gs,df,dg,svars,l);

    % Substitute in the given point
    for ii = 1:numel(svars)
        eqns{ii}(l) = subs(r{ii},svars,xstar);
    end

    try
        solstruct = solve(str2sym(string(eqns)),l);
        l1 = double(solstruct.l1);
        l2 = double(solstruct.l2);
        lambdas = [ l1 l2 ].';
        el = string(l.');
    catch
        lambdas = []; el = [];
        for ii = 1:numel(eqns)
            for jj = 1:numel(l)
                lambdas = [ lambdas double(solve(str2sym(string(eqns{ii})),l(jj))) ];
                el = [ el string(l(jj)) ];
            end
        end
        lambdas = lambdas.';
        el = el.';
    end
end