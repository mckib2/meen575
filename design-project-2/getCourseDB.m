function [ courseDB ] = getCourseDB()
    courseDB = CourseDB([    
        % CS Courses
        Course('CS142',3,[],10);
        Course('CS235',3,{ 'CS142' },10);
        Course('CS236',3,{ 'CS235' },10);
        Course('CS240',4,{ 'CS236' },10);
        Course('CS340',3,{ 'CS240' },10);
        Course('CS224',3,{ 'CS142' },10);
        Course('CS345',3,{ 'CS224' 'CS240' },10);
        Course('CS428',3,{ 'CS340' },10);
        Course('CS431',3,{ 'CS340' },10);
        Course('CS452',3,{ 'CS240' },10);
        Course('CS355',3,{ 'CS240' 'MATH313' },10);
        Course('CS455',3,{ 'CS355' 'MATH313' },10);
        Course('CS256',3,{ 'CS142' },10);
        Course('CS456',3,{ 'CS240' 'CS256' },10);
        Course('CS324',3,{ 'CS224' 'CS240' },10);
        Course('CS460',3,{ 'CS324' },10);
        Course('CS462',3,{ 'CS324' 'CS340' },10);
        Course('CS465',3,{ 'CS324 -c' },10);
        Course('CS252',3,{ 'CS236 -c' },10);
        Course('CS312',3,{ 'CS240' 'CS252' },10);
        Course('CS470',3,{ 'CS312' 'MATH313' 'STAT201' },10);
        Course('CS478',3,{ 'CS312' 'MATH113' 'STAT201' },10);

        % ECEN courses
        Course('ECEN191',.5,[],1);
        Course('ECEN220',3,{ 'CS142 -c' },6);
        Course('ECEN240',4,{ 'MATH113' 'PHSCS220' },6);
        Course('ECEN330',4,{ 'CS235' 'ECEN220' },10);
        Course('ECEN340',4,{ 'ECEN240' },10);
        Course('ECEN360',4,{ 'CS235' 'ECEN220' },5);
        Course('ECEN380',4,{ 'ECEN240' 'MATH334' },5);
        Course('ECEN390',3,{ 'ECEN330' 'ECEN340' 'ECEN380' },10);
        Course('ECEN391',.5,{ 'ECEN240' },1);
        Course('ECEN475',3,{ 'ECEN390' 'STAT201' },10);
        Course('ECEN476',3,{ 'ECEN475' },10);
        Course('ECEN323',4,{ 'CS235' 'ECEN220' },4);
        Course('ECEN443',4,{ 'ECEN340' },4);
        Course('ECEN445',4,{ 'ECEN340' },4);
        Course('ECEN450',3,{ 'ECEN340' },4);
        Course('ECEN452',1,{ 'ECEN450 -c' },2);
        Course('ECEN462',2,{ 'ECEN360' },4);
        Course('ECEN464',2,{ 'ECEN462' },5);
        Course('ECEN466',2,{ 'ECEN462' },4);
        Course('ECEN483',4,{ 'ECEN380' },5);
        Course('ECEN485',4,{ 'ECEN380' 'STAT201' },5);
        Course('ECEN487',4,{ 'ECEN380' 'STAT201' },6);
        Course('ECEN424',4,{ 'ECEN323' 'ECEN330' },10);
        Course('ECEN425',4,{ 'ECEN323' 'ECEN330' },10);
        Course('ECEN427',4,{ 'ECEN323' 'ECEN330' },10);


        % MATH courses
        Course('MATH112',4,[],3,1);
        Course('MATH113',4,{ 'MATH112' },3,1);
        Course('MATH313',3,{ 'MATH112' },3);
        Course('MATH314',3,{ 'MATH113' },4);
        Course('MATH334',3,{ 'MATH113' 'MATH313'},3);
        Course('MATH290',3,{ 'MATH112 -c' },4);
        Course('MATH341',3,{ 'MATH113' 'MATH290' },4);
        Course('MATH342',3,{ 'MATH313' 'MATH341' },4);
        Course('MATH352',3,{ 'MATH290' 'MATH341 -c' },3);
        Course('MATH355',3,{ 'MATH313' },2);
        Course('MATH371',3,{ 'MATH290' 'MATH313' },3);
        Course('MATH372',3,{ 'MATH371' },3);
        Course('MATH411',3,{ 'MATH334' },4);
        Course('MATH447',3,{ 'MATH314' 'MATH334' },4);
        Course('MATH450',3,{ 'MATH371' },4);
        Course('MATH487',3,{ 'MATH371' },4);

        % Physics Courses
        Course('PHSCS121',3,{ 'MATH112 -c' },4);
        Course('PHSCS220',3,{ 'MATH113' 'PHSCS121' },5);
        Course('PHSCS123',3,{ 'PHSCS121' 'MATH112' },3);
        Course('PHSCS222',3,{ 'PHSCS123' 'PHSCS220' },4);

        % Statisitics courses
        Course('STAT201',3,{ 'MATH112' },2)

        % Chemistry Courses
        Course('CHEM105',4,[],3)

        % English Courses
        Course('ENGL201',3,[],3);
        Course('ENGL202',3,[],3,1);
        Course('ENGL211',3,[],3);
        Course('ENGL212',3,[],3,1);
        Course('ENGL230',3,[],3);
        Course('ENGL232',3,[],3);
        Course('ENGL235',3,[],3);
        Course('ENGL236',3,[],3);
        Course('ENGL238',3,[],3);
        Course('ENGL268',3,[],3);
        Course('ENGL316',3,{ 'WRTG150' },4);
        Course('ENGL310',3,{ 'WRTG150' },4);
        Course('ENGL311',3,{ 'WRTG150' },4);
        Course('ENGL312',3,{ 'WRTG150' },4);
        Course('ENGL391',3,[],4);

        % Writing Courses
        Course('WRTG150',3,[],3);

        % Religion courses
        Course('RELA121',2,[],2,1);
        Course('RELA122',2,[],2,1);
        Course('RELA275',2,[],2,1);
        Course('RELA211',2,[],2,1);
        Course('RELA250',2,[],2,1);
        Course('RELA311R',3,[],3,1);
        Course('RELC225',2,[],2,1);
        Course('RELC200',2,[],2,1);
        Course('RELC333',2,[],3,1);
        Course('RELA212',2,[],3,1);
        Course('RELA301',2,[],3,1);
        Course('RELA302',2,[],3,1);
        Course('RELA303R',3,[],3,1);
        Course('RELA304',2,[],3,1);
        Course('RELA320',2,[],3,1);
        Course('RELA327',2,[],3,1);
        Course('RELA392R',3,[],3,1);
        Course('RELC100',2,[],3,1);
        Course('RELC130',2,[],1,1); 
        Course('RELC234',2,[],3,1);
        Course('RELC261',2,[],3,1);
        Course('RELC293R',1,[],3,1);
        Course('RELC324',2,[],3,1);
        Course('RELC325',2,[],3,1);
        Course('RELC333',2,[],3,1);
        Course('RELC341',2,[],3,1);
        Course('RELC342',2,[],3,1);
        Course('RELC343',2,[],3,1);
        Course('RELC344',2,[],3,1);
        Course('RELC350R',3,[],3,1);
        Course('RELC351',2,[],3,1);
        Course('RELC352',2,[],3,1);
        Course('RELC353',2,[],3,1);
        Course('RELC357',2,[],3,1);
        Course('RELC358',2,[],3,1);
        Course('RELC393R',3,[],3,1);
        Course('RELC431',2,[],3,1);
        Course('RELC471',2,[],3,1);

        % School of Family Life Courses
        Course('SFL200',3,[],2,1);

        % American Heritage Courses
        Course('AHTG100',3,[],5);

        % Econ Classes
        Course('ECON110',3,[],6,1);
        Course('ECON230',3,{ 'ECON110' },5);

        % HIST Courses
        Course('HIST201',3,[],3);
        Course('HIST202',3,[],3,1);
        Course('HIST217',3,[],3);
        Course('HIST290',3,[],3);
        Course('HIST310',3,[],3);
        Course('HIST398',3,[],3);
        Course('HIST220',3,[],3);
        Course('HIST221',3,[],3);
        Course('HIST231',3,[],3);
        Course('HIST261',3,[],3);
        Course('HIST293',3,[],3);
        Course('HIST302',3,[],3);
        Course('HIST303',3,[],3);
        Course('HIST312',3,[],3);
        Course('HIST324',3,[],3);
        Course('HIST333',3,[],3);
        Course('HIST355',3,[],3);
        Course('HIST366',3,[],3);

        % POLI Courses
        Course('POLI150',3,[],2,1);
        Course('POLI200',4,[],2);
        Course('POLI201',3,[],2);
        Course('POLI202',3,[],2,1);
        Course('POLI210',3,{ 'POLI200' },2,1);
        Course('POLI110',3,[],2,1);
        Course('POLI170',3,[],2,1);
        Course('POLI347',3,[],3);
        Course('POLI353',3,[],3);
        Course('POLI354',3,[],3);
        Course('POLI385',3,[],3);
        Course('POLI472',3,[],3);

        % ANTHRO Course
        Course('ANTHR101',3,[],3,1);
        Course('ANTHR110',3,[],3,1);
        Course('ANTHR330',3,[],3);
        Course('ANTHR335',3,[],3);
        Course('ANTHR340',3,[],3);

        % ARTHC Course
        Course('ARTHC111',3,[],3);
        Course('ARTHC201',3,[],3);
        Course('ARTHC202',3,[],3,1);
        Course('ARTHC203',3,[],3);

        % CLCV Course
        Course('CLCV110',3,[],4);
        Course('CLCV201',3,[],4);
        Course('CLCV202',3,[],4,1);
        Course('CLCV241',3,[],4);
        Course('CLCV245',3,[],4);
        Course('CLCV246',3,[],4);

        % CMLIT
        Course('CMLIT201',3,[],4);
        Course('CMLIT202',3,[],4,1);
        Course('CMLIT211',3,[],4);
        Course('CMLIT212',3,[],4,1);

        % ENGT Courses
        Course('ENGT231',3,[],4,1);

        % EUROP Courses
        Course('EUROP200',3,[],4,1);
        Course('EUROP336R',6,[],4);

        % RECM Courses
        Course('RECM300',3,[],2);

        % Geography Courses
        Course('GEOG120',3,[],3);
        Course('GEOG130',3,[],3);
        Course('GEOG255',3,[],4);
        Course('GEOG260',3,[],4);
        Course('GEOG265',3,[],4);
        Course('GEOG271',3,[],4);
        Course('GEOG272',3,[],4);
        Course('GEOG273',3,[],4);
        Course('GEOG285',3,[],4);


        % UNIV Courses
        Course('UNIV291',3,{ 'WRTG150' },4,1);
        Course('UNIV292',3,{ 'WRTG150' },4,1);
        Course('UNIV293',3,{ 'WRTG150' },4,1);
        Course('UNIV210R',3,[],4);
        Course('UNIV214R',3,[],4);

        % IAS Course
        Course('IAS221',3,[],4);
        Course('IAS353R',3,[],4);

        % IHUM Course
        Course('IHUM101',3,[],3);
        Course('IHUM201',3,[],3);
        Course('IHUM202',3,[],31);
        Course('IHUM240',3,[],3,2);
        Course('IHUM241',3,[],3,1);
        Course('IHUM242',3,[],3,1);
        Course('IHUM260',3,[],3,1);
        Course('IHUM261',3,[],3);
        Course('IHUM262',3,[],3);

        % MESA Courses
        Course('MESA250',3,[],4);

        % MUSIC Courses
        Course('MUSIC101',3,[],3)
        Course('MUSIC201',3,[],3);
        Course('MUSIC202',3,[],3,1);
        Course('MUSIC203',3,[],3,1);
        Course('MUSIC204',3,[],3);

        % PWS Courses
        Course('PWS101',3,[],4);
        Course('PWS150',3,[],4,1);

        % SCAND Courses
        Course('SCAND217',3,[],4,1);

        % SOC Courses
        Course('SOC113',3,[],3);
        Course('SOC323',3,[],4);

        % Women's Studies
        Course('WS222',3,[],3);

        % PHIL Classes
        Course('PHIL110',3,[],4);
        Course('PHIL150',3,[],4);
        Course('PHIL201',3,[],4);
        Course('PHIL202',3,[],4,1);
        Course('PHIL210',3,[],4);
        Course('PHIL211',3,[],4,1);
        Course('PHIL214',3,[],4);
        Course('PHIL213',3,[],4);
        Course('PHIL215',3,[],4);

        % GERM Course
        Course('GERM217',3,[],4,1);

        % TMA
        Course('TMA201',3,[],4);
        Course('TMA202',3,[],4,1);
        Course('TMA101',3,[],4);
        Course('TMA102',3,[],4);

        % ART
        Course('ART101',3,[],3);
        Course('ART104',3,[],3);
        Course('ART105',3,[],3);

        % DANCE
        Course('DANCE260',3,[],2);

        % FNART
        Course('FNART270R',6,[],3);

        % FREN
        Course('FREN317',3,[],3);
        Course('FREN321',3,[],4);
        Course('FREN361',3,{ 'FREN321' },4);
        Course('FREN362',3,[],3);

        % SFL
        Course('SFL102',3,[],4);

        % BIO
        Course('BIO100',3,[],4);
        Course('BIO130',4,[],4);

        % PSYCH
        Course('PSYCH111',3,[],4);

        % EMPTY
        Course('EMPTY',0,[],0);

    ]);
end