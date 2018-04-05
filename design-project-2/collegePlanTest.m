
close all;
clear;

courseDB = CourseDB([    
    % CS Courses
    Course('CS142',3,[]);
    Course('CS235',3,{ 'CS142' });
    Course('CS236',3,{ 'CS235' });
    Course('CS240',4,{ 'CS236' });
    Course('CS340',3,{ 'CS240' });
    Course('CS224',3,{ 'CS142' });
    Course('CS345',3,{ 'CS224' 'CS240' });
    Course('CS428',3,{ 'CS340' });
    Course('CS431',3,{ 'CS340' });
    Course('CS452',3,{ 'CS240' });
    Course('CS355',3,{ 'CS240' 'MATH313' });
    Course('CS455',3,{ 'CS355' 'MATH313' });
    Course('CS256',3,{ 'CS142' });
    Course('CS456',3,{ 'CS240' 'CS256' });
    Course('CS324',3,{ 'CS224' 'CS240' });
    Course('CS460',3,{ 'CS324' });
    Course('CS462',3,{ 'CS324' 'CS340' });
    Course('CS465',3,{ 'CS324 -c' });
    Course('CS252',3,{ 'CS236 -c' });
    Course('CS312',3,{ 'CS240' 'CS252' });
    Course('CS470',3,{ 'CS312' 'MATH313' 'STAT201' });
    Course('CS478',3,{ 'CS312' 'MATH113' 'STAT201' });

    % ECEN courses
    Course('ECEN191',.5,[]);
    Course('ECEN220',3,{ 'CS142 -c' });
    Course('ECEN240',4,{ 'MATH113' 'PHSCS220' });
    Course('ECEN330',4,{ 'CS235' 'ECEN220' });
    Course('ECEN340',4,{ 'ECEN240' });
    Course('ECEN360',4,{ 'CS235' 'ECEN220' });
    Course('ECEN380',4,{ 'ECEN240' 'MATH334' });
    Course('ECEN390',3,{ 'ECEN330' 'ECEN340' 'ECEN380' });
    Course('ECEN391',.5,{ 'ECEN240' });
    Course('ECEN475',3,{ 'ECEN390' 'STAT201' });
    Course('ECEN476',3,{ 'ECEN475' });
    Course('ECEN323',4,{ 'CS235' 'ECEN220' });
    Course('ECEN443',4,{ 'ECEN340' });
    Course('ECEN445',4,{ 'ECEN340' });
    Course('ECEN450',3,{ 'ECEN340' });
    Course('ECEN452',1,{ 'ECEN450 -c' });
    Course('ECEN462',2,{ 'ECEN360' });
    Course('ECEN464',2,{ 'ECEN462' });
    Course('ECEN466',2,{ 'ECEN462' });
    Course('ECEN483',4,{ 'ECEN380' });
    Course('ECEN485',4,{ 'ECEN380' 'STAT201' });
    Course('ECEN487',4,{ 'ECEN380' 'STAT201' });
    Course('ECEN424',4,{ 'ECEN323' 'ECEN330' });
    Course('ECEN425',4,{ 'ECEN323' 'ECEN330' });
    Course('ECEN427',4,{ 'ECEN323' 'ECEN330' });


    % MATH courses
    Course('MATH112',4,[]);
    Course('MATH113',4,{ 'MATH112' });
    Course('MATH313',3,{ 'MATH112' });
    Course('MATH314',3,{ 'MATH113' });
    Course('MATH334',3,{ 'MATH113' 'MATH313'});
    Course('MATH290',3,{ 'MATH112 -c' });
    Course('MATH341',3,{ 'MATH113' 'MATH290' });
    Course('MATH342',3,{ 'MATH313' 'MATH341' });
    Course('MATH352',3,{ 'MATH290' 'MATH341 -c' });
    Course('MATH355',3,{ 'MATH313' });
    Course('MATH371',3,{ 'MATH290' 'MATH313' });
    Course('MATH372',3,{ 'MATH371' });
    Course('MATH411',3,{ 'MATH334' });
    Course('MATH447',3,{ 'MATH314' 'MATH334' });
    Course('MATH450',3,{ 'MATH371' });
    Course('MATH487',3,{ 'MATH371' });

    % Physics Courses
    Course('PHSCS121',3,{ 'MATH112 -c' });
    Course('PHSCS220',3,{ 'MATH113' 'PHSCS121' });
    Course('PHSCS123',3,{ 'PHSCS121' 'MATH112' });
    Course('PHSCS222',3,{ 'PHSCS123' 'PHSCS220' });

    % Statisitics courses
    Course('STAT201',3,{ 'MATH112' })

    % Chemistry Courses
    Course('CHEM105',4,[])

    % English Courses
    Course('ENGL316',3,{ 'WRTG150' });

    % Writing Courses
    Course('WRTG150',3,[]);
]);

% Requirement 1 - Complete 21 Courses
req1 = Requirement({
    'CS142';
    'CS235';
    'ECEN191';
    'ECEN220';
    'ECEN240';
    'ECEN330';
    'ECEN340';
    'ECEN360';
    'ECEN380';
    'ECEN390';
    'ECEN391';
    'ECEN475';
    'ECEN476';
    'MATH112';
    'MATH113';
    'MATH313';
    'MATH314';
    'MATH334';
    'PHSCS121';
    'PHSCS220';
    'STAT201'; },65);

% Requirement 2 - Complete 2 Options
% Choose the options - it doesn't matter
req2 = Requirement({ 'CHEM105'; 'ENGL316' },7);

% Requirement 3 - Complete 16 hours from the following
req3 = Requirement({ 'ECEN323'; 'ECEN443'; 'ECEN445'; 'ECEN450'; ...
    'ECEN452'; 'ECEN462'; 'ECEN464'; 'ECEN466'; 'ECEN483'; 'ECEN485'; ...
    'ECEN487'; },16);

% Requirement 4 - Complete 2 hours from the following
req4 = Requirement({ 'CS236'; 'CS240'; 'CS340'; 'CS345'; 'CS428'; ...
    'CS431'; 'CS452'; 'CS455'; 'CS456'; 'CS460'; 'CS462'; 'CS465'; ...
    'CS470'; 'CS478'; 'ECEN323'; 'ECEN424'; 'ECEN425'; 'ECEN427'; ...
    'ECEN443'; 'ECEN445'; 'ECEN450'; 'ECEN452'; 'ECEN462'; 'ECEN464'; ...
    'ECEN466'; 'ECEN483'; 'ECEN485'; 'ECEN487'; 'MATH341'; 'MATH342'; ...
    'MATH352'; 'MATH355'; 'MATH371'; 'MATH372'; 'MATH411'; 'MATH447'; ...
    'MATH450'; 'MATH487'; 'PHSCS222'; },2);

requirements = [ req1 req2 req3 req4 ];

% This is what the GA would give us:
sem1 = Semester({ 'WRTG150' 'MATH112' 'CHEM105' 'CS142' 'ECEN191' },courseDB);
sem2 = Semester({ 'CS235' 'MATH113' 'PHSCS121' },courseDB);
sem3 = Semester({ 'ECEN220' 'MATH313' 'PHSCS220' },courseDB);
sem4 = Semester({ 'ECEN240' 'MATH314' 'MATH334' },courseDB);
sem5 = Semester({ 'ECEN330' 'ECEN340' 'ECEN380' 'ECEN391' },courseDB);
sem6 = Semester({ 'ECEN360' 'STAT201' 'ECEN390' },courseDB);
sem7 = Semester({ 'ECEN475' },courseDB);
sem8 = Semester({ 'ECEN476' 'ENGL316' },courseDB);

semesters = [ sem1 sem2 sem3 sem4 sem5 sem6 sem7 sem8 ];
cp = CollegePlan(courseDB,requirements,semesters);




