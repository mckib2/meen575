%     0 => MATLAB's forward difference
%     1 => MATLAB's central difference
%     2 => Forward Difference
%     3 => Central Difference
%     4 => Complex Step

function [ g ] = get_g(gflag,x,obj,h)

    % make sure we have a step
    if isempty(h)
        h = 1e-4;
    end

    % decode gflag
    if ismember(gflag,[ 0 1 ])
        % use MATLAB default, nothing to do
        g = [];
    elseif gflag == 2
        
        % custom forward difference rule
        g = zeros(size(x));
        f0 = obj(x);
        for ii = 1:numel(x)
            xp = zeros(size(x)); xp(ii) = h;
            g(ii) = (obj(x + xp) - f0)/h; 
        end
        
    elseif gflag == 3
        
        % custom central difference rule
        g = zeros(size(x));
        for ii = 1:numel(x)
            xp = zeros(size(x)); xp(ii) = h;
            g(ii) = (obj(x + xp) - obj(x - xp))/(2*h);
        end
    
    elseif gflag == 4
    
        % custom complex step rule
        g = zeros(size(x));
        for ii = 1:numel(x)
            xp = zeros(size(x)); xp(ii) = 1j*h;
            g(ii) = imag(obj(x + xp))/h;
        end
        
    end

end