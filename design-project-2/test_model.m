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
            obj.fitness = sum(obj.vs);
        end
    end
end