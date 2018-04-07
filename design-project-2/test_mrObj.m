%% Model Testing

clear;
close all;

%% Params
gamma = 42.58e3;
B0 = 1.5;
offres = 10; % Hz
T1 = 600; % ms
T2 = 100; % ms
T2star = [];
Rho = 1;
x = 1;
y = 1;
z = 1;

%% Testing
a = mrObj(gamma,B0,offres,T1,T2,T2star,Rho,x,y,z);

% Initialize
dt = 1; % ms
n = 1000; % time steps
Mz = zeros(n,1); Mxy = Mz; Mx = Mz; My = Mz;
Mz(1) = a.getMz(1,1,1); Mxy(1) = a.getMxy(1,1,1);
Mx(1) = a.getMx(1,1,1); My(1) = a.getMy(1,1,1);

% Create an MR sequence
rf = [ 0   pi/3;
       100 pi/3;
       200 pi/3 ];

% adc = [ 
s = sequence(rf,[],[],[],[]);

% Run the sequence on the object
[ im ] = s.run(a);

% %% Look at one point reading out for n time steps
% for ii = 2:n
% %     if mod(ii,10)
% %         a.excite(pi/6);
% %     end
%     Mz(ii) = a.getMz(1,1,1);
%     Mxy(ii) = a.getMxy(1,1,1);
%     Mx(ii) = a.getMx(1,1,1);
%     My(ii) = a.getMy(1,1,1);
%     a.precess(dt);
% end
% 
% figure(1);
% plot(dt*(1:n),Mz,'DisplayName','Mz'); hold on; grid on;
% plot(dt*(1:n),Mxy,'DisplayName','Mxy');
% plot(dt*(1:n),Mx,'DisplayName','Mx');
% plot(dt*(1:n),My,'DisplayName','My');
% title('Transverse and Longitudinal Relaxation');
% xlabel('t (ms)');
% ylabel('Amplitude');
% legend(gca,'show');