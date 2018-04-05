classdef CourseDB < handle
    properties
        courses;
    end
    
    methods
        
        function [ obj ] = CourseDB(courses)
            obj.courses = courses;
        end
        
        function [ course ] = get(obj,courseID)
            
            course = -1;
            for ii = 1:numel(obj.courses)
                if strcmp(obj.courses(ii).id,courseID)
                    course = obj.courses(ii);
                    break;
                end
            end
        end
        
    end
end