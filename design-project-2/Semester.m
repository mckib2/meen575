classdef Semester < handle
    properties
        courseIDs;
        courses;
        reqTime;
        creditHours;
        gpa;
        miscHours;
        workHours;
        tuition;
        studyHours;
        housing;
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
            
            % Let's get our hours in
            obj.miscHours = (55+35)*16; % 55 hours per week per semester (16 weeks)
            
            % Costs
            obj.housing = 500*4; % $200 for 4 months
        end
        
        function [  ] = calcTuition(obj,prevGPA)
            
            % Add in Tuition rates
            if obj.creditHours >= 12
                obj.tuition = 2730;
            elseif obj.creditHours >= 9
                obj.tuition = 2594;
            else
                obj.tuition = 286*obj.creditHours;
            end
            
            % Now factor in scholarship
            if (prevGPA >= 3.93) && (obj.creditHours >= 12)
                obj.tuition = 0;
            elseif (prevGPA >= 3.79) && (obj.creditHours >= 12)
                obj.tuition = .5*obj.tuition;
            end
            
            % Update Work,Study Hours
            obj.calcWorkHours();
            obj.calcStudyHours();
            obj.calcGPA();
        end
        
        function [  ] = calcWorkHours(obj)
            tot_cost = obj.tuition + obj.housing;
            obj.workHours = tot_cost/12; % Assume $12 an hour campus job
%             if obj.workHours>20*16
%                 obj.workHours = 20*16;
%             end
            
        end
        
        function [ ] = calcStudyHours(obj)
            obj.studyHours = 24*7*16 - obj.miscHours - obj.workHours;
        end
        
        function [ ] = calcGPA(obj)
            % Find the difficulty of the semester
            tot_diff = 0;
            for ii = 1:numel(obj.courseIDs)
                tot_diff = tot_diff + obj.courses(ii).difficulty;
            end
            
            % For each class, find the GPA
            gpa0 = 0;
            for ii = 1:numel(obj.courseIDs)
                c = obj.courses(ii);
                timespent = (c.difficulty/tot_diff)*obj.studyHours;
                gpaNew = 4*timespent/(c.difficulty*c.creditHours*16);
                
                % Make sure grade inflation doesn't inflate
                if gpaNew > 4
                    gpaNew = 4;
                end
                
                % Cumsum
                gpa0 = gpa0 + gpaNew;
            end
            
            obj.gpa = gpa0/numel(obj.courseIDs);
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