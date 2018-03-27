function [ next_gen ] = genalg(fitfun,curr_gen,mutrate)

    % selection
    [ p1,p2 ] = select(curr_gen,fitfun,5,3);
    
    % crossover
%     cross();
    
    % mutation
%     mutate(mutrate);
    
    % elitism
%     creamthecrop();

    next_gen = [];

end