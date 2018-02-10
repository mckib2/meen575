% Based on algorithm given here:
% https://en.wikipedia.org/wiki/Backtracking_line_search

function [ alpha ] = backtracking(alpha,x0,s,g0,obj)
    c = 1/2; tau = .1;
    f0 = obj(x0);
    m = s.'*g0;
    t = -c*m;
    
    while 1
        if ((f0 - obj(x0 + alpha*s)) >= alpha*t)
            % Found an acceptable alpha!
            break;
        else
            alpha = tau*alpha;
        end
    end
end