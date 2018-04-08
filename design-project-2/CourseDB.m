classdef CourseDB < handle
    properties
        courses;
    end
    
    methods
        
        function [ obj ] = CourseDB(courses)
            obj.courses = courses;
        end
        
        function [ course,idx ] = get(obj,courseID)
            
            course = -1; idx = -1;
            for ii = 1:numel(obj.courses)
                if strcmp(obj.courses(ii).id,courseID)
                    course = obj.courses(ii);
                    idx = ii;
                    break;
                end
            end
        end
        
        function [ ] = apply(obj,id)
            [ ~,idx ] = obj.get(id);
            obj.courses(idx).applied = 1;
            fprintf('%s is now applied!\n',id);
        end
        
        function [ ] = removeDoubler(obj,id)
            [ ~,idx ] = obj.get(id);
            obj.courses(idx).doubler = obj.courses(idx).doubler - 1;
            fprintf('%s double counted!\n',id);
        end
        
    end
end