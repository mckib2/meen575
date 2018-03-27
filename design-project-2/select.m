function [ p1,p2 ] = selectps(curr_gen,fitfun,k,n)
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
        candidates(ii,:) = randsample(curr_gen,n);
    end
    
    % Calculate fitness
    fitness = fitfun(candidates);
    
    % Select the most fit parents
    [ ~,I ] = max(fitness,[],2);
    parents = candidates(I);
end