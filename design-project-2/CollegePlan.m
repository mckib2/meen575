classdef CollegePlan < handle
    properties
        semesters;
        requirements;
        courseDB;
        CourseBin;
        TakenBin;
        gpa;
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
            obj.CourseBin = obj.getCourseBin();
            
            % Initialize the taken courses bin
            obj.TakenBin = obj.courseDB.get('EMPTY');
        end
        
        function [ val ] = works(obj)
            
        end
        
        function [ val ] = getFit(obj)
            prevGPA = 0;
            totGPA = 0;
            coursenumpen = 0;
            for ii = 1:numel(obj.semesters)
                s = obj.semesters(ii);
                s.calcTuition(prevGPA);
                totGPA = totGPA + s.gpa;
                
                % Penalty term for many courses
                if s.creditHours > 19
                    coursenumpen = coursenumpen + 1;
                end
                
                % Update prevGPA
                prevGPA = s.gpa;
            end
            totGPA = totGPA/numel(obj.semesters);
            obj.gpa = totGPA;
            %val = totGPA - (1/3)*numel(obj.semesters);
            val = totGPA - 0.008*exp(numel(obj.semesters)/1.5) - 1.5*coursenumpen;
            %val = totGPA - numel(obj.semesters);
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
        
        function [ sem ] = generatePrefSemester(obj,pref)
            sem = Semester({},obj.courseDB);
            for ii = 1:numel(pref.courseIDs)
                c = obj.courseDB.get(pref.courseIDs(ii));
                if ismember(c.id,obj.CourseBin)
                    % Check prereqs
                    prereqs = findPrereq(c,obj.courseDB);
                    if isequal(prereqs,c)
                        sem.add(c.id,obj.courseDB);
                    end
                end
            end
            
            obj.TakenBin = obj.getTakenBin();
            obj.CourseBin = obj.getCourseBin();
            sem = obj.generateSemester(sem,30 - pref.creditHours);
        end
        
        function [ sem ] = generateSemester(obj,varargin)
            
            % max credits
            maxCreds = 30;
            
            % Start with a fresh semester
            
            if nargin > 1
                sem = varargin{1};
                credHrs0 = varargin{2};
                credHrs = sem.creditHours + credHrs0;
            else
                sem = Semester({ });
                
                %  Choose a level to start the credit bucket at
                credHrs0 = randi(12,1,1);
                credHrs = credHrs0;
            end
            
            % Keep adding courses till we run out of room
            stop = false;
            cntr = 0;
            while ((credHrs <= maxCreds) && ~isempty(obj.CourseBin) && ~stop && (cntr < 10))
                cntr = cntr + 1;
                idx = randi([ 1 numel(obj.CourseBin) ],1,1);
                courseID = obj.CourseBin(idx);
                c = obj.courseDB.get(courseID{1});
                
                % Check for prereqs
                prereqs = unique(findPrereq(c,obj.courseDB));

                numprereqs = numel(prereqs);
                
                if ~isequal(prereqs,c)
                    % Remove courses that we have already taken
                    % prereqs = setdiff(prereqs,obj.TakenBin);
                    % This actually takes a double loop because MATLAB
                    % object arrays don't support set operations...
                    prereqs2 = [];
                    for kk = 1:numel(prereqs)
                        hastaken = 0;
                        for mm = 1:numel(obj.TakenBin)
                            if strcmp(prereqs(kk).id,obj.TakenBin(mm).id)
                                hastaken = 1;
                            end
                        end
                        
                        if ~hastaken
                            prereqs2 = [ prereqs2 prereqs(kk) ];
                        end
                    end
                    if ~isempty(prereqs2)
                        prereqs = prereqs2;
                    end
 

                    % Add all the courses that we can
                    for ii = 1:numel(prereqs)
                        if ~(credHrs + prereqs(ii).creditHours > maxCreds)
                            
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
                                    
                                    % Additionally, if this course
                                    % completed a requirement, we need to
                                    % take out all of those types of
                                    % classes that fulfill the requirement.
                                    %[ ~,b ] = obj.isConsistent();
                                    %for nn = 1:numel(obj.requirements)
                                    %    if b(nn)
                                    %        obj.CourseBin = setdiff(obj.CourseBin,obj.requirements(nn).courseIDs);
                                    %    end
                                    %end
                                    TakenIDs = {};
                                    for nn = 1:numel(obj.TakenBin)
                                        TakenIDs = [ TakenIDs obj.TakenBin(nn).id ];
                                    end
                                    for nn = 1:numel(obj.requirements)
                                        if obj.requirements(nn).isSatisfied([ TakenIDs sem.courseIDs ],obj.courseDB)
                                            obj.CourseBin = setdiff(obj.CourseBin,obj.requirements(nn).courseIDs);
                                        end
                                    end
                                    
                                    % If req 3 is not satisfied, then add
                                    % those classes back in minus the ones
                                    % that you've taken
                                    if ~obj.requirements(4).isSatisfied([ TakenIDs sem.courseIDs ],obj.courseDB)
                                        obj.CourseBin = setdiff(union(obj.CourseBin,obj.requirements(4).courseIDs),[ TakenIDs sem.courseIDs ]);
                                    end
                                    
                                end
                            else
                                % This means all the prereqs were
                                % satisfied, so add the course proper
                                sem.add(c.id,obj.courseDB);
                                
                                 if (sem.isConsistent(obj.TakenBin) <= 0) && (numel(obj.CourseBin) > 1)
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
                    if ~(credHrs + c.creditHours > maxCreds)

                        doit = 1;
                        for kk = 1:numel(obj.TakenBin)
                            if strcmp(c.id,obj.TakenBin(kk).id) || ismember(c.id,sem.courseIDs)
                                %disp(c.id);
                                doit = 0;
                                break;
                            end
                        end
                        
                        if doit
                            sem.add(c.id,obj.courseDB);
                            credHrs = sem.creditHours + credHrs0;
                            obj.CourseBin = setdiff(obj.CourseBin,c.id);
                            
                            % Additionally, if this course
                            % completed a requirement, we need to
                            % take out all of those types of
                            % classes that fulfill the requirement.
                            %[ ~,b ] = obj.isConsistent();
                            %for nn = 1:numel(obj.requirements)
                            %    if b(nn)
                            %        obj.CourseBin = setdiff(obj.CourseBin,obj.requirements(nn).courseIDs);
                            %    end
                            %end
                            TakenIDs = {};
                            for nn = 1:numel(obj.TakenBin)
                                TakenIDs = [ TakenIDs obj.TakenBin(nn).id ];
                            end
                            for nn = 1:numel(obj.requirements)
                                isSat = obj.requirements(nn).isSatisfied([ TakenIDs sem.courseIDs ],obj.courseDB);
                                if isSat
                                    obj.CourseBin = setdiff(obj.CourseBin,obj.requirements(nn).courseIDs);
                                end
                            end
                            
                            % If req 3 is not satisfied, then add
                            % those classes back in minus the ones
                            % that you've taken
                            if ~obj.requirements(4).isSatisfied([ TakenIDs sem.courseIDs ],obj.courseDB)
                                obj.CourseBin = setdiff(union(obj.CourseBin,obj.requirements(4).courseIDs),[ TakenIDs sem.courseIDs ]);
                            end
                        end
                    else
                        stop = 1;
                        break;
                    end
                end
            end
            
            % Now add the semester object to the list of semesters
            if ~isempty(sem.courseIDs)
                obj.semesters = [ obj.semesters sem ];
            end
            
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
        
        function [ ] = print(obj)
            % Header
            fprintf('College Plan, GPA: %f, fitness: %f, num sem: %d\n',obj.gpa,obj.getFit(),numel(obj.semesters));
            
            % Print out each semester
            for ii = 1:numel(obj.semesters)
                fprintf('\t Semester %d:\n',ii)
                sem_list = join(obj.semesters(ii).courseIDs);
                fprintf('\t\t %s\n',sem_list{1});
            end
        end
       
        function [ ] = mutate(obj)
            % Randomly choose a semester that will be mutated
            idx = randi([ 1 floor(numel(obj.semesters)) ],1,1);
            obj.semesters(idx+1:end) = [];
            
            % Reset the CourseBin and TakenBin
            obj.TakenBin = obj.getTakenBin();
            obj.CourseBin = obj.getCourseBin();
            
            % Generate new semesters from here onwards
            b = 0;
            while ~all(b)
                obj.generateSemester();
                [ ~,b ] = obj.isConsistent();
            end
            
        end
        
        function [ takenBin ] = getTakenBin(obj)
            takenBin = [];
            for ii = 1:numel(obj.semesters)
                takenBin = [ takenBin obj.semesters(ii).courses(:)' ];
            end
        end
        
        function [ courseBin ] = getCourseBin(obj)
            
            % Default course bin construction
            courseBin = {};
            for ii = 1:numel(obj.requirements)
                courseBin = [ courseBin obj.requirements(ii).courseIDs(:)'];
            end
            courseBin = unique(setdiff(courseBin,''));
            
            % Get Course IDs
            TakenIDs = {};
            for ii = 1:numel(obj.TakenBin)
                TakenIDs = [ TakenIDs obj.TakenBin(ii).id ];
            end

            % Now remove courses based on requirements
            for nn = 1:numel(obj.requirements)
                isSat = obj.requirements(nn).isSatisfied(TakenIDs,obj.courseDB);
                if isSat
                    courseBin = setdiff(courseBin,obj.requirements(nn).courseIDs);
                end
            end

            % If req 3 is not satisfied, then add
            % those classes back in minus the ones
            % that you've taken
            if ~obj.requirements(4).isSatisfied(TakenIDs,obj.courseDB)
                courseBin = setdiff(union(courseBin,obj.requirements(4).courseIDs),TakenIDs);
            end

            % Remove the courses taken
            for ii = 1:numel(obj.TakenBin)
                courseBin = setdiff(courseBin,obj.TakenBin(ii).id);
            end

        end
        
    end
end