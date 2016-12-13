% This script runs the Matlab assignments from Lecture 4 on EGM and DC-EGM
% Written by Fedor Iskhakov, 2015

addpath('utils');

%create the model objects
m1=model_phelps
m2=model_deaton

%solve phelps model with VFI
fprintf('\nSolving %s with value function iterations:\n',m1.label)
m1.solve_vfi;
m1.plot('policy');


fprintf('Press any key to continue (stop 1)\n');
pause

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

fprintf('Press any key to continue (stop 2)\n');
pause

fprintf('Error in simulated consumption is %1.5e\n', ...
	max(max(m3.sims.consumption')-min(m3.sims.consumption'))/mean(m3.sims.consumption(:)));

m3.nsims=10;

m3.sim
m3.plot('sim consumption')

m2.sim
m2.plot('sim consumption')


fprintf('Press any key to continue (stop 3)\n');
pause

m4=model_deaton
m4.nsims=100
m4.solve_egm
m4.sim
m4.plot('sims')


