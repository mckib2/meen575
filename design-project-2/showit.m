function [ ] = showit(gen,t)
    figure; grid on; hold on;
    for ii = 1:numel(gen)
        plot(numel(gen(ii).semesters),gen(ii).gpa,'kp');
        drawnow;
    end
    title(t);
    xlabel('Number of Semester');
    ylabel('GPA');
    xlim([ 6 15 ]);
    ylim([ 0 4 ]);
end