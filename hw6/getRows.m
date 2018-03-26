function [ r ] = getRows(gs,df,dg,svars,l)
    r = cell(1,numel(svars)+numel(gs));
    for ii = 1:numel(svars)
        r{ii}(svars,l) = df{ii};
        for jj = 1:numel(gs)
            r{ii}(svars,l) = r{ii} - l(jj)*dg{ii}{jj};
        end
    end
    for jj = 1:numel(gs)
        r{numel(svars)+jj}(svars,l) = -gs{jj};
    end
end