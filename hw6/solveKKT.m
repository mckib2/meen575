function [ A,b ] = solveKKT(f,g)
    syms l
    svars = symvar(f);
    x1 = svars(1);
    x2 = svars(2);
    
    % Get derivates
    dfx1 = diff(f,x1);
    dfx2 = diff(f,x2);
    dgx1 = diff(g,x1);
    dgx2 = diff(g,x2);

    % Form rows r1 -> r3
    r1(x1,x2,l) = dfx1 - l*dgx1;
    r2(x1,x2,l) = dfx2 - l*dgx2;
    r3(x1,x2,l) = -g;
    
    % Make a cell array out of the rows so we can pass it to sym2mat
    rs = { r1,r2,r3 };
    
    % Now fill in matrices A and b, pulling out the coefficients from
    % symbolic functions created above.
    [ A,b ] = sym2mat(rs);
end