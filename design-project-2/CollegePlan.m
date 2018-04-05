classdef CollegePlan < handle
    properties
    end
    
    properties(Access = private)
        isSatisfied;
    end
    
    methods
        
        function [ obj ] = CollegePlan(courseDB,requirements,semesters)
            
            taken = { };
            % Make sure that the semesters are consistent
            for ii = 1:numel(semesters)
                good = semesters(ii).isConsistent(taken);
                fprintf('Semester %d is %d\n',ii,good);
                taken = [ taken semesters(ii).courseIDs ];
            end
            
            % We need to make sure that all the requirments are fulfilled
            % by all the classes we've taken
            for ii = 1:numel(requirements)
                good = requirements(ii).isSatisfied(taken,courseDB);
                fprintf('Requirement %d is %d\n',ii,good);
            end
                      
        end
        
    end
end