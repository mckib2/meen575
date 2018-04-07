classdef Course < handle
    properties
        id;
        creditHours;
        prereqs;
        applied;
        doubler; % double counts
        difficulty;
        reqTime;
    end
    
    properties(Access = private)
    end
    
    methods
        
        function [ obj ] = Course(id,creditHours,prereqs,difficulty,varargin)
            obj.id = id;
            obj.creditHours = creditHours;
            obj.prereqs = prereqs;
            obj.difficulty = difficulty;
            
            % Figure out if we double count or not
            if nargin > 4
                obj.doubler = varargin{1};
            else
                obj.doubler = 0;
            end
            
            obj.applied = 0;
            
            % Calculate required time
            obj.reqTime = obj.creditHours*((7/9)*obj.difficulty + 2/9);
        end
        
    end
end