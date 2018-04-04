classdef gpa < handle
    properties
        
    end
    properties(Access = private)
        fit;
    end
    
    methods
        
        function [ obj ] = gpa()
            
            % lazy fitness evaluation
            obj.fit = [];
        end
        
        function [ fit ] = getFit(obj)
            % If we haven't evaluated the fitness, go ahead and do so
            if isequal(obj.fit,[])
                % objective function here
                obj.fit = 0;
                fit = obj.fit;
            else
                % Grab the already evaluated fitness function
                fit = obj.fit;
            end
            
        end
        
    end
end