%% Homework 1
% Nicholas McKibben
% MEEn 575
% 2018-01-11

clear;
close all;

%% Get some extrema points
N = 5;
[ x0_neg_sqp,xopt0_neg_sqp,fopt0_neg_sqp,~,history ] = optimize_spring(N,@(x) -x,'sqp');

%% Contour Plots
% We'll have to keep a couple variables contant to represent the space on
% the contour plot.  We'll choose d vs D and hold n,hf constant.

w = .18;
Q = 15e4;
G = 12e6;
Se = 45e3;
Sf = 1.5;
h0 = 1;
delta0 = .4;
hdef = h0 - delta0;
hf = xopt0_neg_sqp(1,4);
n = xopt0_neg_sqp(1,3);
d0 = xopt0_neg_sqp(1,1);
D0 = xopt0_neg_sqp(1,2);
F0 = -fopt0_neg_sqp(1);

dmax = .2;
dmin = .01;
Dmax = 1.5;
Dmin = .04;

d = linspace(dmin,dmax,700);
D = linspace(Dmin,Dmax,700);
[X,Y] = meshgrid(d,D);

Sy = 0.44*Q./(d0^w);
hs = n*X;
hs0 = n*d0;
k = G*X.^4./(8*Y.^3*n);
k0 = G*d0^4/(8*D0^3*n);
K = (4*Y - X)./(4*(Y - X)) + 0.62*X./Y;
K0 = (4*D0 - d0)/(4*(D0 - d0)) + 0.62*d0/D0;
m = 8*K.*Y./(pi*X.^3);
m0 = 8*K0*D0/(pi*d0^3);
t_hs = (hf - hs).*k.*m;
t_hs0 = (hf - hs0)*k0*m0;
tmax = (hf - h0 + delta0).*k.*m;
tmax0 = (hf - h0 + delta0)*k0*m0;
tmin = (hf - h0).*k.*m;
tmin0 = (hf - h0)*k0*m0;
tm = (tmax + tmin)./2;
tm0 = (tmax0 + tmin0)/2;
ta = (tmax - tmin)./2;
ta0 = (tmax0 - tmin0)/2;

fig1 = figure(1);

% Change size of figure
xywh = get(gcf,'position');
units = get(gcf,'units');
set(gcf,'units',units,'position',[xywh(1),xywh(2),800,500]);

ls = 1000; % label spacing
[ C_force,h ] = contour(X,Y,(hf - h0)*k,[0.1,1,2,3,4,5,6,7],'k'); % plot the force
clabel(C_force,h,'LabelSpacing',500);

% Plot the constraint contours
hold on;
[ C,h ] = contour(X,Y,Y./X,[4,16],'r','LineWidth',2); % 4 <= D/d <= 16
clabel(C,h,'LabelSpacing',ls);

[ C,h ] = contour(X,Y,X + Y,[.75,.75],'g','LineWidth',2); % D + d < 0.75 % active
clabel(C,h,'LabelSpacing',ls);

[ C,h ] = contour(X,Y,hdef - hs,[.05,.05],'b','LineWidth',2); % hdef - hs > 0.05 % active
clabel(C,h,'LabelSpacing',ls);

[ C,h ] = contour(X,Y,ta,[Se/Sf,Se/Sf],'y','LineWidth',2); % ta <= Se/Sf
clabel(C,h,'LabelSpacing',ls);

[ C,h ] = contour(X,Y,ta + tm,[Sy/Sf,Sy/Sf],'cy','LineWidth',2); % ta + tm <= Sy/Sf % active
clabel(C,h,'LabelSpacing',ls);

[ C,h ] = contour(X,Y,t_hs,[Sy,Sy],'m','LineWidth',2); % t_hs < Sy
clabel(C,h,'LabelSpacing',ls);

% Plot the point
plot(d0,D0,'r*','MarkerSize',10,'LineWidth',2);
text(d0-.0025,D0+.062,sprintf('d = %f\nD = %f\nF = %f',d0,D0,F0),'HorizontalAlignment','center','BackgroundColor',[.6,.6,.6]);

% Shade the feasible region
xfeas = [ .0239;.04426;.072437;.0496 ];
yfeas = [ .3853;.7082;.677563;.5542 ];
h = fill(xfeas,yfeas,[.9,.9,.9],'LineStyle','none');
uistack(h,'bottom');

title('Feasible Space');
xlabel('wire diameter, d (in)');
ylabel('coil diameter, D (in)');
legend('Feasible Region','F','4 <= D/d <= 16','D + d < 0.75','h_{def} - h_s > .05','t_a <= S_e/S_f|_{d=d_{opt}}','t_a + t_m <= S_y/S_f|_{d=d_{opt}}','t_hs < Sy','Location','northwest','Optimum');
axis([ .02 .075 .3 .8 ]);

% Same figure, but "zoomed out"
fig2 = copyobj(fig1,0);
axis([ dmin dmax Dmin Dmax ]);
legend('Location','northeast');

%% Plot the histories
% close all;

for nn = 1:size(history,2)
    figure(nn + 2);
    h = history(nn);
    xmin = min(h.x(:,1));
    xmax = max(h.x(:,1));
    ymin = min(h.x(:,2));
    ymax = max(h.x(:,2));
    
    [X,Y] = meshgrid(linspace(xmin,xmax,300),linspace(ymin,ymax,300));
    k = G*X.^4./(8*Y.^3.*n);
    [ C,hh ] = contour(X,Y,(hf - h0)*k,'k'); % plot the force
    clabel(C,hh,'LabelSpacing',ls);
    title(sprintf('Start Point %d',nn));
    xlabel('wire diameter, d (in)');
    ylabel('coil diameter, D (in)');
    hold on;

    plot(h.x(:,1),h.x(:,2),'-r.');
    for xx = 1:size(h.x)
        plot(h.x(xx,1),h.x(xx,2));
        text(h.x(xx,1),h.x(xx,2),num2str(xx),'FontSize',7);
    end
    
    h = fill(xfeas,yfeas,[.9,.9,.9],'LineStyle','none');
    uistack(h,'bottom');
end

%% Generate some tables

% Show several starting points
startingpoints = table( ...
    x0_neg_sqp(:,1), ...
    x0_neg_sqp(:,2), ...
    x0_neg_sqp(:,3), ...
    x0_neg_sqp(:,4), ...
    'VariableNames',...
    {'d0','D0','n0','hf0'}, ...
    'RowNames', ...
    {'x_init0','x_init1','x_init2','x_init3','x_init4'});
disp(startingpoints);

% Show several end points and function values to verify we get to the same
% optimum point
endpoints = table( ...
    xopt0_neg_sqp(:,1), ...
    xopt0_neg_sqp(:,2), ...
    xopt0_neg_sqp(:,3), ...
    xopt0_neg_sqp(:,4), ...
    -fopt0_neg_sqp, ...
    'VariableNames', ...
    {'d_opt','D_opt','n_opt','hf_opt','F'}, ...
    'RowNames', ...
    {'x_opt0','x_opt1','x_opt2','x_opt3','x_opt4'});
disp(endpoints);
    
% Optimum Values
dvars = table( ...
    xopt0_neg_sqp(1,:)', ...
    'VariableNames', ...
    {'DesignVariables'}, ...
    'RowNames', ...
    {'wire diameter, d','coil diameter, D','coil number, n','free height, hf'});
disp(dvars);

