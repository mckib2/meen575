function [ next_gen ] = genalg(curr_gen,mutrate,crossrate)

    % selection
    [ parents ] = select(curr_gen,5,3);
    
    % crossover
    [ children ] = cross(parents,crossrate);
    
    % mutation
%     mutate(mutrate);
    
    % elitism
    [ next_gen ] = creamthecrop(parents,children);

end