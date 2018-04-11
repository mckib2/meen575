function [ curr,fit ] = findbest(gen)
    curr = gen(1);
    fit = curr.getFit();
    for ii = 1:numel(gen)
        if gen(ii).getFit() > fit
            curr = gen(ii);
            fit = curr.getFit();
        end
    end
end