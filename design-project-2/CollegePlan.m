classdef CollegePlan < handle
    properties
        semesters;
        requirements;
        courseDB;
        CourseBin;
        TakenBin;
    end
    
    properties(Access = private)
        isSatisfied;
    end
    
    methods
        
        function [ obj ] = CollegePlan(requirements,semesters)
            obj.courseDB = getCourseDB();
            obj.semesters = semesters;
            obj.requirements = requirements;
            
            % Construct the course bin
            obj.CourseBin = {};
            for ii = 1:numel(obj.requirements)
                obj.CourseBin = [ obj.CourseBin obj.requirements(ii).courseIDs(:)'];
            end
            obj.CourseBin = unique(setdiff(obj.CourseBin,''));
            
            % Initialize the taken courses bin
            obj.TakenBin = obj.courseDB.get('EMPTY');
        end
        
        function [ val ] = works(obj)
            
        end
        
        function [ val ] = getFit(obj)
%             
%             for ii = 1:numel(self.semesters)
%                 for jj = 1:numel(self.semesters(ii).courses)
%                     c = self.semesters(ii).courses(jj);
%                     gpa = 4.3*c.timespent/(((7/9)*c.difficulty + 2/9)*c.creditHours);
            
        end
        
        function [ prereqsFulfilled,requirementsFulfilled ] = isConsistent(obj)
            taken = { };
            % Make sure that the semesters are consistent
            prereqsFulfilled = zeros(1,numel(obj.semesters));
            for ii = 1:numel(obj.semesters)
                prereqsFulfilled(ii) = obj.semesters(ii).isConsistent(taken);
                %fprintf('Semester %d is %d\n',ii,prereqsFulfilled(ii));
                taken = [ taken obj.semesters(ii).courseIDs ];
            end
            
            % We need to make sure that all the requirments are fulfilled
            % by all the classes we've taken
            requirementsFulfilled = zeros(1,numel(obj.requirements));
            for ii = 1:numel(obj.requirements)
                requirementsFulfilled(ii) = obj.requirements(ii).isSatisfied(taken,obj.courseDB);
                %fprintf('Requirement %d is %d\n',ii,requirementsFulfilled(ii));
            end
            
            % Fix so we get logical values
            prereqsFulfilled(prereqsFulfilled < 0) = 0;
            
            % Reset everything
            obj.courseDB = getCourseDB();
        end
        
        function [ sem ] = generateSemester(obj)
            % Start with a fresh semester
            sem = Semester({ });
            
            %  Choose a level to start the credit bucket at
            credHrs0 = randi(6,1,1);
            credHrs = credHrs0;
            
            % Keep adding courses till we run out of room
            stop = false;
            while ((credHrs < 19) && ~isempty(obj.CourseBin) && ~stop)
                idx = randi([ 1 numel(obj.CourseBin) ],1,1);
                courseID = obj.CourseBin(idx);
                c = obj.courseDB.get(courseID{1});
                
                % Check for prereqs
                prereqs = unique(findPrereq(c,obj.courseDB));

                if ~isequal(prereqs,c)
                    % Remove courses that we have already taken
                    prereqs = setdiff(prereqs,obj.TakenBin);

                    % Add all the courses that we can
                    for ii = 1:numel(prereqs)
                        if ~(credHrs + prereqs(ii).creditHours > 18)
                            
                            doit = 1;                            
                            for kk = 1:numel(obj.TakenBin)
                                if strcmp(prereqs(ii).id,obj.TakenBin(kk).id) || ismember(prereqs(ii).id,sem.courseIDs)
                                    doit = 0;
                                    break;
                                end
                            end
                            
                            if doit
                                sem.add(prereqs(ii).id,obj.courseDB);

                                if sem.isConsistent(obj.TakenBin) <= 0
                                    sem.pop();
                                else
                                    credHrs = sem.creditHours + credHrs0;

                                    % Take this course out of the running - We
                                    % got it!
                                    obj.CourseBin = setdiff(obj.CourseBin,prereqs(ii).id);
                                end
                            else
                                % This means all the prereqs were
                                % satisfied, so add the course proper
                                sem.add(c.id,obj.courseDB);
                                
                                 if sem.isConsistent(obj.TakenBin) <= 0
                                    sem.pop();
                                 else
                                    credHrs = sem.creditHours + credHrs0;
                                    obj.CourseBin = setdiff(obj.CourseBin,c.id);
                                 end
                                 
                                 % Break out of the loop
                                 break;
                            end
                        else
                            stop = 1;
                            break;
                        end
                    end
                else
                    if ~(credHrs + c.creditHours > 18)
                        
                        doit = 1;
                        for kk = 1:numel(obj.TakenBin)
                            if strcmp(c.id,obj.TakenBin(kk).id) || ismember(c.id,sem.courseIDs)
                                disp(c.id);
                                doit = 0;
                                break;
                            end
                        end
                        
                        if doit
                            sem.add(c.id,obj.courseDB);
                            credHrs = sem.creditHours + credHrs0;
                            obj.CourseBin = setdiff(obj.CourseBin,c.id);
                        end
                    else
                        stop = 1;
                        break;
                    end
                end
            end
            
            % Now add the semester object to the list of semesters
            obj.semesters = [ obj.semesters sem ];
            
            % Also add the classes we just added in the semester to the
            % running taken courses list
            obj.TakenBin = [ sem.courses(:)' obj.TakenBin ];
            % Make sure to exclude the 'EMPTY' class - we always want to be able to
            % take that class
            obj.TakenBin = setdiff(obj.TakenBin,obj.courseDB.get('EMPTY'));
            
%             % We also need to take the classes we've already taken out of
%             % the running - so take them out of the course bin!
%             for ii = 1:numel(obj.TakenBin)
%                 obj.CourseBin = setdiff(obj.CourseBin,obj.TakenBin(ii).id);
%             end
            
            % But make sure that the EMPTY class is always there
%             if ~ismember(obj.CourseBin,'EMPTY')
%                 obj.CourseBin = [ 'EMPTY' obj.CourseBin ];
%             end
        end
        
    end
end