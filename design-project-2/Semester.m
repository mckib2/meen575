classdef Semester < handle
    properties
        courseIDs;
        courses;
        reqTime;
    end
    
    methods
        function [ obj ] = Semester(courseIDs,courseDB)
            obj.courseIDs = courseIDs;
            
            % Get the actual courses from the database
            for ii = 1:numel(courseIDs)
                obj.courses = [ obj.courses courseDB.get(courseIDs(ii)) ];
                obj.reqTime = obj.reqTime + obj.courses(end).reqTime;
            end
            
        end
        
        function [ val ] = isConsistent(obj,coursesTaken)
            
            val = 1; % Assume innocent before proven guilty
            concurrent = 0;
            
            for ii = 1:numel(obj.courses)
                
                for jj = 1:numel(obj.courses(ii).prereqs)
                    id = split(obj.courses(ii).prereqs(jj));
                    
                    if numel(id) > 1
                        % We can look in the current semester too for
                        % concurrent prereqs!
                        concurrent = 1;
                    end
                    id = id{1};
                    
                    % Realize you only need to check the current prereq
                    % requirements because we know the whole history!
                    % Now check to see if it's in your previously taken
                    % classes:
                    if ~any(strcmp(coursesTaken,id)) &&  ...
                        ~(concurrent && any(strcmp(obj.courseIDs,id)))
                    
                        fprintf('You haven''t taken %s yet!\n',id);
                        val = -1;
                    end
                    
                    concurrent = 0;

                end
                
            end
        end
    end
end