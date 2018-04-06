classdef Course < handle
    properties
        id;
        creditHours;
        prereqs;
        applied;
        doubler; % double counts
    end
    
    properties(Access = private)
    end
    
    methods
        
        function [ obj ] = Course(id,creditHours,prereqs,varargin)
            obj.id = id;
            obj.creditHours = creditHours;
            obj.prereqs = prereqs;
            
            % Figure out if we double count or not
            if nargin > 3
                obj.doubler = varargin{1};
            else
                obj.doubler = 0;
            end
            
            obj.applied = 0;
        end
        
    end
end