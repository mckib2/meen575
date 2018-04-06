
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
    Course('MATH112',4,[],1);
    Course('MATH113',4,{ 'MATH112' },1);
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
    
    % Religion courses
    Course('RELA121',2,[],1);
    Course('RELA122',2,[],1);
    Course('RELA275',2,[],1);
    Course('RELA211',2,[],1);
    Course('RELA250',2,[],1);
    Course('RELA311R',3,[],1);
    Course('RELC225',2,[],1);
    Course('RELC200',2,[],1);
    Course('RELC333',2,[],1);
    Course('RELA212',2,[],1);
    Course('RELA301',2,[],1);
    Course('RELA302',2,[],1);
    Course('RELA303R',3,[],1);
    Course('RELA304',2,[],1);
    Course('RELA320',2,[],1);
    Course('RELA327',2,[],1);
    Course('RELA392R',3,[],1);
    Course('RELC100',2,[],1);
    Course('RELC130',2,[],1); 
    Course('RELC234',2,[],1);
    Course('RELC261',2,[],1);
    Course('RELC293R',1,[],1);
    Course('RELC324',2,[],1);
    Course('RELC325',2,[],1);
    Course('RELC333',2,[],1);
    Course('RELC341',2,[],1);
    Course('RELC342',2,[],1);
    Course('RELC343',2,[],1);
    Course('RELC344',2,[],1);
    Course('RELC350R',3,[],1);
    Course('RELC351',2,[],1);
    Course('RELC352',2,[],1);
    Course('RELC353',2,[],1);
    Course('RELC357',2,[],1);
    Course('RELC358',2,[],1);
    Course('RELC393R',3,[],1);
    Course('RELC431',2,[],1);
    Course('RELC471',2,[],1);
    
    % School of Family Life Courses
    Course('SFL200',3,[],1);
    
    % American Heritage Courses
    Course('AHTG100',3,[]);
    
]);

% Requirement 1 - Complete 21 Courses
req1 = Requirement({ 'CS142' 'CS235' 'ECEN191' 'ECEN220' 'ECEN240' ...
    'ECEN330' 'ECEN340' 'ECEN360' 'ECEN380' 'ECEN390' 'ECEN391' ...
    'ECEN475' 'ECEN476' 'MATH112' 'MATH113' 'MATH313' 'MATH314' ...
    'MATH334' 'PHSCS121' 'PHSCS220' 'STAT201' },65);

% Requirement 2 - Complete 2 Options
% Choose the options - it doesn't matter
req2 = Requirement({ 'CHEM105' 'ENGL316' },7);

% Requirement 3 - Complete 16 hours from the following
req3 = Requirement({ 'ECEN323' 'ECEN443' 'ECEN445' 'ECEN450' ...
    'ECEN452' 'ECEN462' 'ECEN464' 'ECEN466' 'ECEN483' 'ECEN485' ...
    'ECEN487' },16);

% Requirement 4 - Complete 2 hours from the following
req4 = Requirement({ 'CS236' 'CS240' 'CS340' 'CS345' 'CS428' ...
    'CS431' 'CS452' 'CS455' 'CS456' 'CS460' 'CS462' 'CS465' ...
    'CS470' 'CS478' 'ECEN323' 'ECEN424' 'ECEN425' 'ECEN427' ...
    'ECEN443' 'ECEN445' 'ECEN450' 'ECEN452' 'ECEN462' 'ECEN464' ...
    'ECEN466' 'ECEN483' 'ECEN485' 'ECEN487' 'MATH341' 'MATH342' ...
    'MATH352' 'MATH355' 'MATH371' 'MATH372' 'MATH411' 'MATH447' ...
    'MATH450' 'MATH487' 'PHSCS222' },2);

% Religion Requirement 1 - Complete 1 Course
req5 = Requirement({ 'RELA121' 'RELA122' 'RELA275' },2);

% Religion Requirement 2 - Complete 1 course
req6 = Requirement({ 'RELA211' 'RELA250' 'RELA311R' },2);

% Religion Requirement 3 - Complete 1 course
req7 = Requirement({ 'RELC225' },2);

% Religion Requirement 4 - Complete 1 Course
req8 = Requirement({ 'RELC200' 'RELC333' 'SFL200' },2);

% BYU Religion Hours Requirement 5 - Complete 14 hrs, may double count
req9 = Requirement({ 'RELA121' 'RELA122' 'RELA211' 'RELA212' 'RELA250' ...
    'RELA275' 'RELA301' 'RELA302' 'RELA303R' 'RELA304' 'RELA311R' ...
    'RELA320' 'RELA327' 'RELA392R' 'RELC100' 'RELC130' 'RELC200' ...
    'RELC225' 'RELC234' 'RELC261' 'RELC293R' 'RELC324' 'RELC325' ...
    'RELC333' 'RELC341' 'RELC342' 'RELC343' 'RELC344' 'RELC350R' ...
    'RELC350R' 'RELC351' 'RELC352' 'RELC353' 'RELC357' 'RELC358' ...
    'RELC393R' 'RELC431' 'RELC471' 'RELC472' 'RELC475' 'SFL200' },14);

% American Heritage - Complete 1 option
% Options are rows, give credits as an array
req10 = Requirement({
    'AHTG100' ''        '';      % Option 1.1
    'ECON110' 'HIST220' 'GE114'; % Option 1.2
    'HIST220' 'POLI210' '';      % Option 1.3
    'HIST221' 'POLI110' '';      % Option 1.4
    'HIST221' 'POLI210' '';      % Option 1.5
    'ECON110' 'POLI210' '';      % Option 1.6
    },[ 3 6 6 6 6 6 ]);

% Global and Cultural Awareness - Complete 1 options
req11 = Requirement({
    % Option 2.1 - we're only allowing this one, all the others are not in
    % line with a EE program
    'ANTHR101' 'ANTHR110' 'ANTHR330' 'ANTHR335' 'ANTHR340' 'ANTHR343' ...
    'ARTHC203' 'ECON230' 'ENGT231' 'EUROP200' 'EUROP336R' 'RECM300' ...
    'GEOG120' 'GEOG130' 'GEOG255' 'GEOG260' 'GEOG265' 'GEOG271' ...
    'GEOG272' 'GEOG273' 'GEOG285' 'GERM217' 'HIST202' 'HIST231' ...
    'HIST261' 'HIST293' 'HIST304' 'HIST333' 'HIST355' 'HIST366' ...
    'UNIV292' 'IAS221' 'IAS353R' 'IHUM240' 'IHUM241' 'IHUM242' ...
    'IHUM260' 'JAPAN350' 'JAPAN351' 'JAPAN352' 'KOREA340' 'MESA250' ...
    'MUSIC203' 'MUSIC307' 'POLI170' 'POLI347' 'POLI353' 'POLI354' ...
    'POLI385' 'POLI472' 'PWS101' 'PWS150' 'RELC351' 'RELC352' 'RELC357' ...
    'RELC358' 'SCAND217' 'SOC113' 'SOC323' 'UNIV210R' 'WS222';
    },3);

% First Year Writing - Complete 1 course
req12 = Requirement({ 'PHIL150' 'WRTG150' },3);

% Adv Written and Oral Communication - Complete 1 option
req13 = Requirement({
    % Option 4.1
    'ANTHR499' 'CHEM391' 'ENGL311' 'ENGL312' 'ENGL313' 'ENGL314' ...
    'ENGL315' 'ENGL316' 'GERM340' 'HONRS300R' 'IHUM311' 'MCOM320' ...
    'NEURO316' 'PHIL300' 'PHSCS416' 'PSYCH307' 'RECM487';
    
    % Option 4.2
    'AMST304' 'AMST490' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '';
    
    % Option 4.3
    'HIST200' 'HIST490' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '';
    
    % Option 4.4 - not likely for EE
    
    % Option 4.5
    'ENGL295' 'ENGL495' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '';
    
    % Option 4.6
    'NURS320' 'NURS339' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '';
    
    % Option 4.7
    'HIST200' 'MESA495' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '';
    
    % Option 4.8
    'MESA495' 'POLI200' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '';
    
    % Option 4.9 - not currently offered
    
    % Option 4.10
    'IAS360R' 'IAS361' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '';
    
    % Option 4.11
    'SOC455R' 'SOC456R' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '';
    
    }, [ 3 6 6 6 5 6 7 11 6 ]);


% Quantitative Reasoning - Complete 1 option
% Fulfilled by major requirements
% req14 = Requirement({
%     % Option 5.1
%     'ACC200' 'MATH102' 'MATH110' 'MATH111' 'MATH112' 'MATH113' ...
%     'MATH118' 'MATH119' 'PHIL205' 'PSYCH308' 'SFL260' 'STAT105' ...
%     'STAT121' 'UNIV213R' },2);

% % Languages of Learning - Complete 1 option
% Fulfilled by major requirements
% req15 = Requirement({
%     % Option 6.1
%     'GEOG222' 'MATH112' 'MATH113' 'MATH118' 'MATH119' 'PHIL305' ...
%     'POLI328' 'PSYCH308' 'STAT121';
%     % Option 6.2 - don't consider languages
%     % Option 6.3 - doesn't count anymore
%     % Option 6.4 - don't consider
%     },3 );

% Civ 1 - Complete 1 course
req16 =  Requirement({ 'ARTHC201' 'CLCV201' 'CMLIT201' 'CMLIT211' ...
    'ENGL201' 'ENGL211' 'HIST201' 'IHUM201' 'MUSIC201' 'PHIL201' ...
    'PHIL210' 'POLI201' 'TMA201' },3);

% Civ 2 - Complete 1 course
req17 = Requirement({ 'ARTHC202' 'CLCV202' 'CMLIT202' 'CMLIT212' ...
    'ENGL202' 'ENGL212' 'HIST202' 'IHUM202' 'MUSIC202' 'PHIL202' ...
    'PHIL211' 'POLI202' 'TMA202' },3);

% Arts - Complete 1 course
req18 = Requirement({ 'ART101' 'ART104' 'ART105'  'ARTHC111' 'ARTHC202' ...
    'DANCE260' 'FNART270R' 'FREN317' 'FREN361' 'FREN362' 'GERM217' ...
    'UNIV293' 'MUSIC101' 'MUSIC202' 'MUSIC203' 'MUSIC204' 'PHIL214' ...
    'RUSS344' 'SCAND217' 'SFL102' 'TMA101' 'TMA102' 'TMA202' 'UNIV214R'
    },3);

% Letters - Complete 1 course
req19 = Requirement({ 'CLCV110' 'CLCV202' 'CLCV241' 'CLCV245' 'CLCV246' ...
    'CMLIT202' 'CMLIT212' 'CREOL340' 'ENGL202' 'ENGL212' 'ENGL230' ...
    'ENGL232' 'ENGL235' 'ENGL236' 'ENGL238' 'ENGL268' 'ENGL300R' ...
    'ENGL391' 'FLANG340R' 'HIST302' 'HIST303' 'HIST312' 'HIST324' ...
    'UNIV291' 'ICLND429' 'IHUM202' 'IHUM242' 'IHUM260' 'IHUM261' ...
    'IHUM262' 'IHUM280R' 'PHIL110' 'PHIL202' 'PHIL211' 'PHIL213' ...
    'PHIL215' 'PHIL423R' 'POLI202' 'UNIV215R'},3);

% Biological Science - Complete 1 course
req20 = Requirement({ 'BIO100' 'BIO130' 'UNIV291' 'MMBIO121' 'MMBIO221' ...
    'MMBIO240' 'NDFS100' 'PDBIO120' 'PWS100' 'PWS100' 'PWS150' 'PWS169' ...
    'UNIV216R'},3);

% Physical Science is covered by major requirements

req21 = Requirement({ 'ANTHR101' 'ANTHR110' 'ECON110' 'ENGT231' ...
    'HIST217' 'HIST290' 'HIST310' 'HIST398' 'UNIV293' 'POLI110' ...
    'POLI150' 'POLI170' 'PSYCH111' 'UNIV218R'},3);


requirements = [ req1 req2 req4 req3 req5 req6 req7 req8 req9 req10 ...
    req11 req12 req13  req16 req17 req18 req19 req20 ];

% This is what the GA would give us:
sem1 = Semester({ 'WRTG150' 'MATH112' 'CHEM105' 'CS142' 'ECEN191' 'RELA275' },courseDB);
sem2 = Semester({ 'CS235' 'MATH113' 'PHSCS121' 'AHTG100' 'RELA250' },courseDB);
sem3 = Semester({ 'ECEN220' 'MATH313' 'PHSCS220' 'RELC225' },courseDB);
sem4 = Semester({ 'ECEN240' 'MATH314' 'MATH334' 'SFL200' },courseDB);
sem5 = Semester({ 'ECEN330' 'ECEN340' 'ECEN380' 'ECEN391' 'RELC200' },courseDB);
sem6 = Semester({ 'ECEN360' 'STAT201' 'ECEN390' 'RELA212' },courseDB);
sem7 = Semester({ 'ECEN475' 'ECEN323' 'ECEN462' 'ECEN483' 'ECEN462' },courseDB);
sem8 = Semester({ 'ECEN476' 'ENGL316' 'RELA301' 'ECEN487' 'ECEN485' },courseDB);

semesters = [ sem1 sem2 sem3 sem4 sem5 sem6 sem7 sem8 ];
cp = CollegePlan(courseDB,requirements,semesters);




