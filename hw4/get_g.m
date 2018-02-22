%     0 => MATLAB's forward difference
%     1 => MATLAB's central difference
%     2 => Forward Difference
%     3 => Central Difference
%     4 => Complex Step

function [ g ] = get_g(gflag,x,fun,h,c)

    % make sure we have a step
    if isempty(h)
        h = 1e-4;
    end
    % check to see if we are doing constraint gradients
    if ~exist('c','var')
        % We are doing objective gradients
        c = [];
        g = zeros(size(x));
        xp_proto = g;
    else
        % We are doing constraint gradients
        g = zeros(size(c.'));
        xp_proto = g;
    end

    % decode gflag
    if ismember(gflag,[ 0 1 ])
        
        % use MATLAB default, nothing to do
        g = [];
        
    elseif gflag == 2
        
        % custom forward difference rule
        f0 = fun(x);
        for ii = 1:numel(x)
            xp = xp_proto; xp(ii) = h;
            if isempty(c)
                g(ii) = (fun(x + xp) - f0)/h;
            else
                g(ii,:) = (fun(x + xp) - f0)/h;
            end
        end
        
    elseif gflag == 3
        
        % custom central difference rule

        for ii = 1:numel(x)
            xp = xp_proto; xp(ii) = h;
            if isempty(c)
                g(ii) = (fun(x + xp) - fun(x - xp))/(2*h);
            else
                g(ii,:) = (fun(x + xp) - fun(x - xp))/(2*h);
            end
        end
    
    elseif gflag == 4
    
        % custom complex step rule
        for ii = 1:numel(x)
            xp = xp_proto; xp(ii) = 1j*h;
            if isempty(c)
                g(ii) = imag(fun(x + xp))/h;
            else
                g(ii,:) = imag(fun(x + xp))/h;
            end
        end
        
    end

end