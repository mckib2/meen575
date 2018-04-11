function [ next_gen ] = genalg(curr_gen,mutrate,crossrate)

    % selection
    [ parents ] = select(curr_gen,30,7);
    
    % crossover
    %[ children ] = cross(parents,crossrate);
    crosscnt = 0;
    for ii = 1:size(parents,1)
        if rand(1) < crossrate
            % Perform crossover
            [ c1,c2 ] = CollegePlanCross(parents(ii,1),parents(ii,2));
            children(ii,:) = [ c1 c2 ];
            crosscnt = crosscnt + 1;
        else
            children(ii,:) = parents(ii,:);
        end
    end
    fprintf('We crossed over %d times\n',crosscnt);
    
    % mutation
    mutcnt = 0;
    for ii = 1:size(children,1)
        if rand(1) < mutrate
            % Mutate a pair of children
            children(ii,1).mutate();
            children(ii,2).mutate();
            mutcnt = mutcnt + 1;
        end
    end
    fprintf('We mutated %d times\n',mutcnt);
    
    % elitism
    [ next_gen ] = creamthecrop(parents,children);

end