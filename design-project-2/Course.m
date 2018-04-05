classdef Course < handle
    properties
        id;
        creditHours;
        prereqs;
    end
    
    properties(Access = private)
    end
    
    methods
        
        function [ obj ] = Course(id,creditHours,prereqs)
            obj.id = id;
            obj.creditHours = creditHours;
            obj.prereqs = prereqs;
        end
        
    end
end