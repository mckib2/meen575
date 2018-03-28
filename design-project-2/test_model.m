% Define our model
classdef test_model
    properties
        fitness;
        vs;
    end
    methods
        function [ obj ] = test_model(v1,v2,v3,v4,v5,v6)
            if nargin > 1
                obj.vs = [ v1 v2 v3 v4 v5 v6 ];
            else
                obj.vs = v1;
            end
            
            obj.fitness = [];
        end
        
        function [ fitval ] = getFit(obj)
            % If we haven't already found the fitness,  go ahead and do so
            if isequal(obj.fitness,[])
                obj.fitness = sum(obj.vs);
            end
            
            fitval = obj.fitness;
        end
    end
end