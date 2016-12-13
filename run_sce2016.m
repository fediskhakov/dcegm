% This is the script to be used in the lecture 7 of SCE2016 Thessaloniki
% Written by Fedor Iskhakov, 2016

%create the model objects
% m1=model_phelps
m2=model_deaton

% %solve phelps model with VFI
% fprintf('\nSolving %s with value function iterations:\n',m1.label)
% m1.solve_vfi;
% m1.plot('policy');

% return
%%

m2.df=1/(1+m2.r);
m2.sigma=0;
m2.init=[30 35];
fprintf('\nSolving %s with value function iterations:\n',m2.label)
m2.solve_vfi;

m3=model_deaton;
m3.df=1/(1+m3.r);
m3.sigma=0;
m3.init=[30 35];
m3.nsims=1;
m3.solve_egm;

m3.sim;
m3.plot('sim consumption');

fprintf('Done, press any key to continue\n')
pause 

fprintf('Error in simulated consumption is %1.5e\n', ...
  max(max(m3.sims.consumption')-min(m3.sims.consumption'))/mean(m3.sims.consumption(:)));

m3.nsims=10;

m3.sim
m3.plot('sim consumption')

m2.sim
m2.plot('sim consumption')

return
%%

m3.plot('value')

return
%%

m3
m3.nsims=100;
m3.init=[5 30];
m3.sim
m3.plot('sims consumption')
m3.plot('sims wealth0')
m3.plot('sims income')



