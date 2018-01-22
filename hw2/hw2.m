%% Homework 2
% Nicholas McKibben
% MEEn 575
% 2018-01-21

%% Optimize!
clear;
close all;
[ xopt,fopt,Ptot,~,~ ] = optimize_slurry();


%% Let's mesh it
fprintf('Cost of %f\nPtot of %f\n',fopt,Ptot);
V = xopt(1);
D = xopt(2);
d = xopt(3);

% Choose V and D for contour plot vars
[Vm,Dm] = meshgrid(linspace(10,15,500),linspace(.001,.1,500));

% Generate all vals
[L,W,a,~,c,~,~,Qw,rho,Pg,f,fw,g,rhow,Cd,S,Rw,mu,gamma,delp,gc,Q,Pf,Vc] = getvals(Vm,Dm,d,0,1);

%% Contour plots
figure(2);
[ C,h ] = contour(Vm,Dm,cost(Pg,Pf));
clabel(C,h);
hold on;

% Plot the optimum
plot(V,D,'r*');

% Show some constraints
contour(Vm,Dm,Vc,[V*1.1,V*1.1]); % V = Vc*1.1
contour(Vm,Dm,c,[.4,.4],'--'); % c < .4
contour(Vm,Dm,Dm,[.5,.5]); % D < 6 in
% clabel(C,h);

title('Slurry Pipeline Contour Plot');
xlabel('Average flow velocity, V (ft/sec)');
ylabel('Internal diameter of pipe, D (ft)');
legend('Cost','Optimum','Vc','c');