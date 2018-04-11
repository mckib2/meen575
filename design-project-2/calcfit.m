function [ avgfit ] = calcfit(gen)
    avgfit = 0;
    for ii = 1:numel(gen)
        avgfit = avgfit + gen(ii).getFit();
    end
    avgfit = avgfit/numel(gen);
end