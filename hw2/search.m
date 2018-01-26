%% Search for the optimum

clear;
close all;

% Load in the optimum values we want to replicate
opt = load('optimum.mat');
D = opt.D; d = opt.d; V = opt.V; obj = opt.objective;

% search points
Vs = linspace(0,20,10);
ds = linspace(.0005,.01,10);

tol = 1e-5;
count = 0;
for ii = 1:numel(Vs)
    for jj = 1:numel(ds)
        Ds = linspace(ds(jj),.01,numel(ds(jj:end))); % D > d
        for kk = 1:numel(Ds)
            count = count + 1;
            fprintf('Evaluating for %d,%d,%d, count is %d\n',ii,jj,kk,count);
            x0 = [ Vs(ii) Ds(kk) ds(jj) ];
            try
                [ xopt,objective,Ptot,~,~ ] = optimize_slurry(1,0,x0);
                V0 = xopt(1);
                D0 = xopt(2);
                d0 = xopt(3);

                if (abs(objective - obj) > tol)
                    fprintf('Houston, we have a problem!\n');
                    disp([V0 D0 d0 objective]);
                end
            catch
                %continue;
            end
        end
    end
end

fprintf('Evaluated %d times\n',count);