function [ prereqs ] = findPrereq(course,courseDB)
    %fprintf('Started to find prereqs...\n');
    prereqs = [];
    if isempty(course.prereqs)
        prereqs = course;
        return;
    else
        for ii = 1:numel(course.prereqs)
            cid = split(course.prereqs{ii});
            p = courseDB.get(cid{1});
            prereqs = [ prereqs p findPrereq(p,courseDB) ];
        end
    end
end