function [ c1,c2 ] = CollegePlanCross(p1,p2)

    % Choose a crossover semester
    idx = randi([ 1 min(numel(p1.semesters),numel(p2.semesters))],1,1);
    
    % grab the requirements
    req = getRequirements();
    
    % Child 1,2
    c1 = CollegePlan(req,[]);
    c1.semesters = p1.semesters(1:idx);
    c1.TakenBin = c1.getTakenBin();
    c1.CourseBin = c1.getCourseBin();
    
    c2 = CollegePlan(req,[]);
    c2.semesters = p2.semesters(1:idx);
    c2.TakenBin = c2.getTakenBin();
    c2.CourseBin = c2.getCourseBin();
    
    % Create a "preferred" set of semesters
    pref1 = p2.semesters(idx+1:end);
    pref2 = p1.semesters(idx+1:end);
    
    b = 0; ii = 1;
    while ~all(b)
        if ii <= length(pref1)
            c1.generatePrefSemester(pref1(ii));
        else
            c1.generateSemester();
        end
        [ ~,b ] = c1.isConsistent();
        ii = ii + 1;
    end
    
end