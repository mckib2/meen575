classdef Semester < handle
    properties
        courseIDs;
        courses;
        reqTime;
        creditHours;
        gpa;
        miscHours;
        workHours;
    end
    
    methods
        function [ obj ] = Semester(courseIDs,courseDB)
            obj.courseIDs = courseIDs;
            obj.creditHours = 0;
            
            % Get the actual courses from the database
            for ii = 1:numel(courseIDs)
                obj.courses = [ obj.courses courseDB.get(courseIDs(ii)) ];
                obj.reqTime = obj.reqTime + obj.courses(end).reqTime;
                obj.creditHours = obj.creditHours + obj.courses(end).creditHours;
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
                    if isobject(coursesTaken)
                        for kk = 1:numel(coursesTaken)

                            if strcmp(coursesTaken(kk).id,id)
                                val = 1;
                                break;
                            elseif (concurrent && any(strcmp(obj.courseIDs,id)))
                                val = 1;
                                break;
                            else
                                val = -1;
                                %fprintf('You haven''t taken %s yet!\n',id);
                                %return;
                            end
                        end
                    else
                         if ~any(strcmp(coursesTaken,id)) &&  ...
                            ~(concurrent && any(strcmp(obj.courseIDs,id)))
                            val = -1;
                         end
                    end
                    
                    if val == -1
                        %fprintf('You haven''t taken %s yet!\n',id);
                        return;
                    end
                    
                    concurrent = 0;

                end
                
            end
        end
        
        function [ ] = add(obj,courseID,courseDB)
            obj.courseIDs = [ obj.courseIDs courseID ];
            obj.courses = [ obj.courses courseDB.get(courseID) ];
            obj.reqTime = obj.reqTime + obj.courses(end).reqTime;
            obj.creditHours = obj.creditHours + obj.courses(end).creditHours;
        end
        
        function [ ] = pop(obj)
            obj.courseIDs = obj.courseIDs(1:end-1);
            c = obj.courses(end);
            obj.courses = obj.courses(1:end-1);
            obj.reqTime = obj.reqTime - c.reqTime;
            obj.creditHours = obj.creditHours - c.creditHours;
        end
        
    end
end