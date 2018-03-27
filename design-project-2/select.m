function [ parents ] = select(curr_gen,k,n)
% [ ] = select()
% Returns k sets of parents (p1,p2) selected from the current generation
% using a tournament size of n.
%
%     curr_gen -- current generation 
%     k -- the number of parent pairs the function will return (both p1
%          and p2 are 1xk in length)
%     n -- tournament size

    % Select two designs from the current design to be the mother, father
    % design.  Selection is based on fitness.  Use tournament method.

    % Randomly select n from the curr_gen
    candidates = zeros(2*k,n);
    for ii = 1:size(candidates,1)
        candidates(ii,:) = randsample(1:numel(curr_gen),n);
        
        for jj = 1:n
            fitness(ii,jj) = curr_gen(candidates(ii,jj)).fitness;
        end
    end
    
    % Calculate fitness
%     fitness = candidates.fitness;
    
    % Select the most fit parents
    rows = (1:size(fitness,1)).';
    [ ~,cols ] = max(fitness,[],2);
    cols = reshape(cols,[],1);
    kk = sub2ind(size(fitness),rows,cols);
    parents = reshape(curr_gen(candidates(kk)),k,2);
end