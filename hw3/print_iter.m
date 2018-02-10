function print_iter(iter,fx,a,optimality)
    global nobj;
     nobj = nobj - 1; % doesn't count
    fprintf(' %d \t  %d \t  %f \t  %f \t  %f\n',iter,nobj,fx,a,optimality);
end