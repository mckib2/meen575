classdef Requirement < handle
    properties
        courseIDs;
        reqCreditHours;
    end
    
    methods
        
        function [ obj ] = Requirement(courseIDs,reqCreditHours)
            obj.courseIDs = setdiff(courseIDs,''); % remove empty strings
            obj.reqCreditHours = reqCreditHours;
        end
        
        function [ val ] = isSatisfied(obj,takenCourseIDs,courseDB)
            
            val = 0; % Guilty until proven innocent
            
            % Each row is a different option, we just need to find an
            % option that we've satisfied.
            for jj = 1:size(obj.courseIDs,1)

                % Find all the courseIDs we can and then count up the credit
                % hours to see if we have enough
                foundCourseIDs = intersect(takenCourseIDs,obj.courseIDs(jj,:));
                
                % Sort by credit hours so we use the least first
                hr = zeros(numel(foundCourseIDs),1);
                for ii = 1:numel(foundCourseIDs)
                    id = foundCourseIDs(ii);
                    
                    %try
                        hr(ii) = courseDB.get(id{1}).creditHours;
                    %catch
                    %end
%                     c = courseDB.get(id{1});
%                     if c ~= -1
%                         hr(ii) = c.creditHours(jj);
%                     end
                end
                [ ~,idx ] = sort(hr,'ascend');
                foundCourseIDs = foundCourseIDs(idx);
                
                hrs = 0;
                for ii = 1:numel(foundCourseIDs)
                    id = foundCourseIDs(ii);
                    
                    % Get the course in question
                    c = courseDB.get(id{1});
                    
                    % Count
                    if ~c.applied || c.doubler
                        hrs = hrs + c.creditHours;
                        
                        % Only double count once
                        if c.doubler && c.applied
                            courseDB.removeDoubler(id{1});
                        end
                        
                        % Apply the course
                        courseDB.apply(id{1});
                        
                        if hrs >= obj.reqCreditHours(jj)
                            val = 1;
                            return;
                        end
                    end
                end
            end
        end
        
    end
end