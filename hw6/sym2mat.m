function [ A,b ] = sym2mat(rs)
% [ A,b ] = sym2mat(rs)
% Given the symbolic rows of A, return A and b with substituted values.
% This function only handles linear constraints.
%
%    rs -- Cell array of symbolic rows of A, in the form given by
%          getRows().
%
%    A  -- Matrix of type double coefficents for the KKT equations.
%    b  -- Right hand side of matrix-form KKT equations.
%

    % Initialize
    A = zeros(numel(rs),numel(symvar(rs{1})));
    b = zeros(numel(rs),1);
    ida = 1; idb = 1;
    for ri = rs
        for si = symvar(ri{1})
            % Get the symbolic coefficients of the rows with respect to the
            % current si
            c = coeffs(ri{1},si,'All');
            
            % Create an argument list of all 0s to suss out the right hand
            % side entry in b
            args1 = num2cell(zeros(size(argnames(c))));            
            
            % Evaluate symbolic function c using argument list
            c1 = fliplr(double(feval(c,args1{:})));
            
            % Sometimes we get nonsense values, skip these with a try-catch
            try
                A(ida) = c1(2); % index 2 is where the sym coeff is
                b(idb) = -c1(1); % index 1 has constants, move to rh-side
            catch
            end
            ida = ida + 1;
        end
        idb = idb + 1;
    end
end