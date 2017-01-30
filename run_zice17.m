% This script runs Matlab assignments from the lecture on EGM and DC-EGM
% rsync -azvhu --progress ~/research/08.teaching/zice2017personal/ZICE17repo/IRS/3_DCEGM/code alphacruncher:zice17/IRS/3_DCEGM/code


addpath('utils');
m=model_deaton %create the model objects

%solve the model with VFI
fprintf('\nSolving %s with value function iterations:\n',m.label)
tic
m.solve_vfi;
t=toc;
fprintf('Done in %s\n',ht(t))
m.plot('policy');

return
%%

%solve the model with EGM
K=100;
fprintf('\nSolving %s with EGM %d times:\n',m.label,K)
tic
for i=1:K
fprintf('.');  
m.solve_egm;
end
t=toc;
fprintf('\nDone in %s, on avarage %s per run\n',ht(t),ht(t/K))

return
%%

%simulate some data
m.nsim=100;
m.sim;
m.sims
m.plot('sim wealth0')
m.plot('sim consumption')

return
%%

%simulate flat consumption paths
m.df=1/(1+m.r);
m.sigma=0;
m.init=[30 35];
m.nsims=2;
m.solve_egm;
m.sim;
m.plot('sim consumption');

m.solve_vfi;
m.sim;
m.plot('sim consumption');

return
%%


%% Flat simulated consumption path using retirement model
m2=model_retirement;
m2.ngridm=500;
m2.df=1/(1+m2.r); %flat consumption hopefully
m2.sigma=0;
m2.lambda=eps; %no EV taste shocks
m2.nsims=5;
m2.init=[5 20];
tic
m2.solve_dcegm;
t=toc;
fprintf('Retirement model solved with DC-EGM in %s\n',ht(t));
m2.plot('policy')
m2.plot('value')
m2.plot('prob_work')
m2.sim;
m2.plot('sim consumption');
ylim=get(gca,'Ylim');
set (gca,'Ylim',[min(min(m2.sims.consumption))-ylim(2)+max(max(m2.sims.consumption)),ylim(2)]);

return
%%

m2.sigma=0.35;
m2.lambda=0.2; %some EV taste shocks
tic
m2.solve_dcegm;
t=toc;
fprintf('Retirement model solved with DC-EGM in %s\n',ht(t));
m2.plot('policy');
m2.plot('value');
m2.plot('prob_work');
m2.nsims=100;
m2.sim;
m2.plot('sim wealth0 consumption income retirement_age')
fprintf('Simulation plots for retirement model produced\n')
