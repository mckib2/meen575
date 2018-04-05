classdef Requirement < handle
    properties
        courseIDs;
        reqCreditHours;
    end
    
    methods
        
        function [ obj ] = Requirement(courseIDs,reqCreditHours)
            obj.courseIDs = courseIDs;
            obj.reqCreditHours = reqCreditHours;
        end
        
        function [ val ] = isSatisfied(obj,takenCourseIDs,courseDB)
            
            val = 0; % Guilty until proven innocent
            
            % Find all the courseIDs we can and then count up the credit
            % hours to see if we have enough
            foundCourseIDs = intersect(obj.courseIDs,takenCourseIDs);
            hrs = 0;
            for ii = 1:numel(foundCourseIDs)
                id = foundCourseIDs(ii);
                hrs = hrs + courseDB.get(id{1}).creditHours;
            end
            
            if hrs >= obj.reqCreditHours
                val = 1;
            end
            
        end
        
    end
end