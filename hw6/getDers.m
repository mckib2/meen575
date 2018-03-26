function [ df,dg,svars,l ] = getDers(f,gs)
    l = sym('l',[ 1 numel(gs) ]);
    svars = symvar(f);
    x = cell(numel(svars),1);
    df = x;
    dg = cell(numel(svars),numel(gs));
    for ii = 1:numel(svars)
        % Discover our symbolic variable args
        x{ii} = svars(ii);
    
        % Get derivatives
        df{ii}(svars) = diff(f,x{ii});
        
        % For each constraint
        for jj = 1:numel(gs)
            dg{ii}{jj}(svars,l) = diff(gs{jj},x{ii});
        end
    end
end