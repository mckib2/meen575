function [ A,b ] = solveKKT(f,gs)
    [ df,dg,svars,l ] = getDers(f,gs);
    
    % Form rows r1 -> rn
    [ r ] = getRows(gs,df,dg,svars,l);
    
    % Now fill in matrices A and b, pulling out the coefficients from
    % symbolic functions created above.
    [ A,b ] = sym2mat(r);
end