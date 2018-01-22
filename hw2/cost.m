% Grinder:
%     300 per horsepower
%     .07 per hp-hr
% Pump
%     200 per horsepower
%     .05 per hp-hr
% 8 hours per day, 300 days per year, plant life of 7 years
% Interest rate is .07
% Recall 1 hp = 550 ft lbf/s
function [ f ] = cost (Pg,Pf)
    totalhr = 2400;
    ii = .07;
    n = 7;
    f = ((300.*Pg + 200.*Pf)./550 + (totalhr./550).*(Pg.*.07 + Pf.*.05).*((1 + ii).^n - 1)./(ii.*(1 + ii).^n));
end