function [L,W,a,V,c,D,d,Qw,rho,Pg,f,fw,g,rhow,Cd,S,Rw,mu,gamma,delp,gc,Q,Pf,Vc] = getvals (V,D,d,useFit,show)

    % Params
    % useFit = 0; % boolean

%     fitType = 'poly2';
    fitType = 'linearinterp'; % piecewise linear interp
%     fitType = 'cubicinterp'; % piecewise cubic interp
%     fitType = 'smoothingspline'; % smoothing spline
%     fitType = 'exp2';
    afun = @(x) log(x);
    iafun = @(x) exp(x);

    % Constants
    mi = 5280; % ft % mi -> feet
    ft = 12; % in % ft -> in
    gc = 32.17; % lbm-ft/lbf-sec^2 % conversion between lbf and lbm
    g = 32.17; % ft/sec^2 % acceleration due to gravity
    rhow = 62.4; % lbm/ft^3 % density of water
    gamma = 168.5; % lbm/ft^3 % limestone density
    mu = 7.392e-4; % lbm/ft-sec % viscosity of water

    % Specified
    L = 15*mi; % mi % Length of pipeling
    W = 12.67; % lbm/sec % flowrate of limestone
    a = 0.01; % ft % average lump size before grinding

    % Design Variables
    %V = 10; % ft/sec % average flow velocity
    %D = 0.01*ft; % internal diameter of pipe
    %d = 0.01*ft; % Average particle size after grinding
    
    A = pi*D.^2./4;
    Q = A.*V;

    Q1 = W./gamma; % ft^3/sec % limestone flow rate
    c = Q1./Q; % Volumetric concentration of slurry
    Qw = Q1.*(1-c)./c; % ft^3/sec % water flow rate
    
    Pg = 218.*W.*(1./sqrt(d) - 1./sqrt(a)); % ft-lbf/sec % power for grinding
    
    Rw = rhow.*V.*D./mu;
    
    fw = ones(size(Rw));
    fw(Rw < 10e5) = 0.3164./Rw(Rw < 10e5).^0.25;
    fw(Rw >= 10e5) = 0.0032 + 0.221.*Rw(Rw >= 10e5).^(-0.237);
    
%     if Rw < 10e5
%         fw = 0.3164./Rw.^0.25;
%     else
%         fw = 0.0032 + 0.221.*Rw.^(-0.237);
%     end

    CdRp2_0 = 4.*g.*rhow.*d.^3.*(gamma - rhow)./(3.*mu.^2);
    afunCdRp2_0 = afun(CdRp2_0);

    % grab the data
    data = xlsread('Cd_vs_CdRp2.xlsx');
    Cds = data(:,1);
    CdRp2s = data(:,2);

    %% Use either fit or nlinfit to get Cd
    if useFit == 1
        [fobj2,gof2] = fit(afun(CdRp2s),afun(Cds),fitType);%,'Robust','LAR');
        R = gof2.rsquare;
        afunCd = fobj2(afunCdRp2_0);

        if show == 1
            figure(1);
            plot(fobj2,[afun(CdRp2s); afunCdRp2_0],[afun(Cds); afunCd]);
            hold on; plot(afunCdRp2_0,afunCd,'r*');
            title('C_dR_p^2 vs C_d');
            ylabel('C_d');
            xlabel('C_dR_p^2');
        end
    else
        expmod = @(b,x) b(1) - b(2).*exp(b(3).*x) - b(4).*exp(b(5).*x);
        opts = statset('RobustWgtFun','fair','MaxIter',Inf);
        [beta,Rx,J,CovB,MSE,ErrorModelInfo] = nlinfit(afun(CdRp2s),afun(Cds),expmod,ones(5,1)/10,opts);

        SST = norm(expmod(beta,afun(CdRp2s)),1)^2;
        SSE = norm(afun(Cds) - expmod(beta,afun(CdRp2s)),2)^2;
        R = (SST - SSE)/SST;

        afunCd = expmod(beta,afunCdRp2_0);

        if show == 1
            figure(1);
            plot(afun(CdRp2s),afun(Cds),'.');
            hold on;
            xs = linspace(-1,25,500).';
            plot(xs,expmod(beta,xs));
            plot(afunCdRp2_0,afunCd,'r*');
            legend('Samples','Fit','afun(Cd)');
        end

    end
    Cd = iafun(afunCd);
    
    if show == 1
        fprintf('R^2 = %f\n',R);
        fprintf('Cd = %f\n',Cd);
    end

    S = gamma./rhow; % specific gravity of the limestone
    rho = rhow + c.*(gamma - rhow); % lbm/ft^3 % slurry density
    f = fw.*(rhow./rho + 150.*c.*(rhow./rho).*((g.*D.*(S - 1))./(V.^2.*sqrt(Cd))).^1.5); % friction factor for the slurry
    delp = f.*rho.*L.*V.^2./(D.*2.*gc); % lbf/ft^2 % pressure drop in pipe due to friction
    Pf = delp.*Q;

    Vc = ((40.*g.*c.*(S-1).*D)./(sqrt(Cd))).^.5;
end