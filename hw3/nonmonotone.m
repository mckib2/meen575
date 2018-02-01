function [ a ] = nonmonotone(s,g0,x0,obj)
    %% Params
    % 0 < nmin <= nmax < 1
    nmin = 1/2; nmax = 1.2;
    
    % 0 < rho < 1
    rho = 1/2;
    
    % delmax < 1
    delmax = 1/2;
    
    % 0 < delmin < (1 - nmax)*delmax
    delmin = .5*(1 - nmax)*delmax;
    
    % amax > 0
    amax = 9;
    
    % M > 1
    M = 500;
    
    % Initialize
    %C = []; Q = []; d = []; x = []; g = [];
    
    k = 1;
    C(k) = obj(x0);
    Q(k) = 1;
    d(:,k) = s;
    x(:,k) = x0;
    g(:,k) = g0;
    
    %% Algorithm (1)
    % Choose nk \in [nmin,nmax], usually away from 1
    nbar(k) = nmin;
    
    % Choose trial step size
    abar(k) = amax; % ak < amax
    
    % Compute Qk+1
    Qbar(k+1) = nbar(k)*Q(k) + 1;
    
    % Compute Clk
    %C(k+1) = (n(k)*Q(k)*C(k) + obj(x(k) + a(k)*d(k)))/Q(k+1);
    Cl(k) = max(C(max(1,k-M+2):k));
    
    % set hk and a1
    hbar(k) = 0;
    ahat(1) = abar(k);
    
    %% Algorithm (2)
    % Choose delk such that delmin <= delk <= delmax.Qk+1
    del(k) = delmax;
    
    %% Algorithm (3->6)
    while (((nbar(k)*Q(k)*C(k) + obj(x(:,k) + ahat(1)*d(:,k)))/Qbar(k+1)) > Cl(k) + del(k)*ahat(1)*g(:,k).'*d(:,k))
        hbar(k) = hbar(k) + 1;
        ahat(1) = abar(k)*rho^hbar(k);
    end
    
    %% Algorithm (7)
    % Compute y1, f1, C1
    ybar(:,1) = x(:,k) + ahat(1)*d(:,k);
    fbar(1) = obj(ybar(:,1));
    Chat(1) = (nbar(k)*Q(k)*C(k) + fbar(1))/Qbar(k+1);
    Cbar(1) = max( max( C(max(1,k-M+3):k ),Chat(1)));
    
    %% Algorithm (8)
    if (fbar(1) <= Cbar(1))
        a(k) = ahat(1);
        x(:,k+1) = ybar(:,1);
        f(k+1) = fbar(1);
        n(k) = nbar(k);
        Q(k+1) = Qbar(k+1);
        C(k+1) = Chat(1);
        Cl(k+1) = Cbar(1);
        
    else
        ahat(2) = abar(k)*rho^hbar(k);
        
        while (obj(x(:,k) + ahat(2)*d(:,k)) > Cl(k) + del(k)*ahat(2)*g(:,k).'*d(:,k))
            hbar(k) =  hbar(k) + 1;
            ahat(2) = abar(k)*rho^hbar(k);
        end
        
        % Compute y2,f2,C2
        ybar(:,2) = x(:,k) + ahat(2)*d(:,k);
        fbar(2) = obj(ybar(:,2));
        Cbar(2) = max( max(C(max(1,k-M+3):k),fbar(2)));
        
        % return these values
        a(k) = ahat(2);
        x(:,k+1) = ybar(:,2);
        f(k+1) = fbar(2);
        n(k) = 0;
        Q(k+1) = Q(k);
        C(k+1) = f(k+1);
        Cl(k+1) = Cbar(2);
    end
    
    a = a(k);
%     C = C(k+1);
%     Q = Q(k+1);
end