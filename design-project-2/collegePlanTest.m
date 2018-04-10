
close all;
clear;

% % This is what the GA would give us:
% sem1 = Semester({ 'WRTG150' 'MATH112' 'CHEM105' 'CS142' 'ECEN191' 'RELA121' },courseDB);
% sem2 = Semester({ 'CS235' 'MATH113' 'PHSCS121' 'AHTG100' 'RELA211' 'PHIL202' },courseDB);
% sem3 = Semester({ 'ECEN220' 'MATH313' 'PHSCS220' 'RELC225' 'ARTHC201' },courseDB);
% sem4 = Semester({ 'ECEN240' 'MATH314' 'MATH334' 'SFL200' 'HIST202' },courseDB);
% sem5 = Semester({ 'ECEN330' 'ECEN340' 'ECEN380' 'ECEN391' 'RELC351' },courseDB);
% sem6 = Semester({ 'ECEN360' 'STAT201' 'ECEN390' 'RELC234' 'UNIV293' },courseDB);
% sem7 = Semester({ 'ECEN475' 'ECEN323' 'ECEN462' 'ECEN483' 'ECEN462' },courseDB);
% sem8 = Semester({ 'ECEN476' 'ENGL316' 'RELA301' 'ECEN487' 'ECEN485' 'UNIV291' },courseDB);
% 
% semesters = [ sem1 sem2 sem3 sem4 sem5 sem6 sem7 sem8 ];
% cp = CollegePlan(courseDB,requirements,semesters);
% 
% 

% %% Construct the Course Bin
% CourseBin = {};
% for ii = 1:numel(requirements)
%     CourseBin = [ CourseBin requirements(ii).courseIDs(:)'];
% end
% CourseBin = unique(CourseBin);
% 
% % Initialize a Courses taken bin
% TakenBin = courseDB.get('EMPTY');

%% Build A College Plan

% rng('default');
[ requirements ] = getRequirements();

% Make a number of them
num_gen = 30;
% collegePlans = { };
for ii = 1:num_gen
    collegePlans(ii) = CollegePlan(requirements,[]);
    a = 0; b = 0;
    while ~all(b)
        collegePlans(ii).generateSemester();
        [ a,b ] = collegePlans(ii).isConsistent();
        % fprintf('%d\n',sum(b));
    end
    fprintf('Number of semesters: %d\n',numel(collegePlans(ii).semesters));
end
