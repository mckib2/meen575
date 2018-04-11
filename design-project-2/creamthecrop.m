function  [ cream ] = creamthecrop(parents,children)
    % The new generation is combined with the previous generation to produce a
    % combined generationof 2N designs, where N is the generation size. The
    % combined generation is sorted by fitness, and the N most fit designs
    % survive as the next parent generation. Thus, children must compete with
    % their parents to survive to the next generation.
    %
    %     parents -- All parents of the desired generation
    %     children -- All children generated from parents
    %
    %     cream -- Resulting generation consisting of the best children and
    %              parents.
    
    % Evaluate all fitnesses.  We can actually do this in parallel to save
    % time
    %parfor ii = 1:numel(parents)
    %    parents(ii).getFit();
    %    children(ii).getFit();
    %end
    
    % Sort the parents and children
    all_gen = [ parents(:); children(:) ];
    fits = zeros(numel(all_gen),1);
    for ii = 1:numel(all_gen)
        fits(ii) = all_gen(ii).getFit();
    end
    
    % We want objects with the highest fit vals
    [ ~,idx ] = maxk(fits,numel(children));
    
    % Send back N of them
    cream = all_gen(idx);
end