function [ A,b ] = sym2mat(rs)
    A = zeros(numel(rs),numel(symvar(rs{1})));
    b = zeros(numel(rs),1);
    ida = 1; idb = 1;
    for ri = rs
        for si = symvar(ri{1})
            c = coeffs(ri{1},si,'All');
            args1 = num2cell(zeros(size(argnames(c))));            
            c1 = fliplr(double(feval(c,args1{:})));
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