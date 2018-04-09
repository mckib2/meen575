function [ requirements, TEBin ] = getRequirements()

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
    req5 = Requirement({ 'RELA121' },2);

    % Religion Requirement 2 - Complete 1 course
    req6 = Requirement({ 'RELA211' },2);

    % Religion Requirement 3 - Complete 1 course
    req7 = Requirement({ 'RELC225' },2);

    % Religion Requirement 4 - Complete 1 Course
    req8 = Requirement({ 'SFL200' },2);

    % BYU Religion Hours Requirement 5 - Complete 14 hrs, may double count
    req9 = Requirement({ 'RELA121' 'RELA211' 'RELC225' 'RELC234' ...
        'RELC351' 'SFL200' 'RELA301' },14);

    % American Heritage - Complete 1 option
    % Options are rows, give credits as an array
    req10 = Requirement({
        'AHTG100' ''       ;      % Option 1.1
        %'HIST220' 'POLI210';      % Option 1.3
        'HIST221' 'POLI110';      % Option 1.4
        %'HIST221' 'POLI210';      % Option 1.5
        %'ECON110' 'POLI210';      % Option 1.6
        },[ 3 6 ]);

    % Global and Cultural Awareness - Complete 1 options
    req11 = Requirement({
        % Option 2.1 - we're only allowing this one, all the others are not in
        % line with a EE program
        'ANTHR101' ...
        'GEOG120' 'GERM217' 'HIST202' ...
        'IHUM240' 'IHUM242' ...
        'PWS150' 'RELC351' },3);

    % First Year Writing - Complete 1 course
    req12 = Requirement({ 'WRTG150' },3);

    % Civ 1 - Complete 1 course
    req13 =  Requirement({ 'ARTHC201' },3);

    % Civ 2 - Complete 1 course
    req14 = Requirement({ 'HIST202' 'ARTHC202' 'CLCV202' },3);

    % Arts - Complete 1 course
    req15 = Requirement({ 'GERM217' 'ARTHC202' 'IHUM240' 'ART101' ...
        'UNIV293' },3);

    % Letters - Complete 1 course
    req16 = Requirement({ 'IHUM240' 'IHUM242' 'CLCV202' 'CLCV241' ...
        'UNIV291' },3);

    % Biological Science - Complete 1 course
    req17 = Requirement({ 'UNIV291' 'PWS150' 'BIO100' 'BIO130' },3);

    % Physical Science is covered by major requirements

    % Social Science
    req18 = Requirement({ 'POLI110' 'ANTHR101' 'UNIV293' ...
        'HIST217' },3);


    requirements = [ req1 req2 req4 req3 req5 req6 req7 req8 req9 req10 ...
        req11 req12 req13 req14 req15 req16 req17 req18 ];

    % What are the TEs?
    TEBin = unique([ req3.courseIDs(:)' req4.courseIDs(:)' ]);
    
end