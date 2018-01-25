%% Homework 2
% Nicholas McKibben
% MEEn 575
% 2018-01-21

%% Optimize!
clear;
close all;

useFit = 1; show = 0;
[ xopt,objective,Ptot,~,~ ] = optimize_slurry(useFit,show);

%% Let's mesh it
fprintf('Cost of %f\nPtot of %f\nPtot (hp) of %f\n',objective,Ptot,Ptot/550);
V = xopt(1);
D = xopt(2);
d = xopt(3);

% Choose V and D for contour plot vars
[Vm,Dm] = meshgrid(linspace(V-3,V+3,500),linspace(D-.1,D+.1,500));

% Generate all mesh vals
[~,~,~,~,c,~,~,Qw,rho,Pg,f,fw,~,~,~,~,Rw,~,~,delp,~,Q,Pf,Vc] = getvals(Vm,Dm,d,useFit,1);

% Generate the single optimum vals and constants
[L,W,a,~,copt,~,~,Qw_opt,rho_opt,Pg_opt,f_opt,fw_opt,g_opt,rhow_opt,Cd_opt,S_opt,Rw_opt,mu,gamma,delp_opt,gc,Q_opt,Pf_opt,Vc_opt] = getvals(V,D,d,useFit,0);

%% Contour plots
figure(2);
ls = 500; % label spacing
[ C,h ] = contour(Vm,Dm,cost(Pg,Pf));
clabel(C,h,'LabelSpacing',ls);
hold on;

% Plot the optimum
plot(V,D,'r*');
text(V+.15,D,sprintf('V=%f\nD=%f\nd=%.1e',V,D,d),'BackgroundColor',[.9 .9 .9]);

% Show some constraints
ls = 1000;
[ C,h ] = contour(Vm,Dm,Vm,[Vc_opt*1.1,Vc_opt*1.2],':'); % 1.1*Vc < V
clabel(C,h,'LabelSpacing',ls);

[ C,h ] = contour(Vm,Dm,c,[.4,.5],'--'); % c < .4
clabel(C,h,'LabelSpacing',ls);

title('Slurry Pipeline Contour Plot');
xlabel('Average flow velocity, V (ft/sec)');
ylabel('Internal diameter of pipe, D (ft)');
legend('Cost','Optimum','V > 1.1*V_c','c < .4');