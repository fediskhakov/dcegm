# EGM and DC-EGM

This repository contains Matlab implementation of EGM and DC-EGM algorithms for solving dynamic stochastic lifecycle models of consumption and savings, with additional discrete choices.

Three models are solved using these methods:
* Phelps model of consumption and savings with stochastic returns (and credit constraints) (EGM)
* Deaton model of consumption and savings with idiosyncratic wage shocks and credit constraints (EGM)
* Model of consumption, saving and retirement decisions with idiosyncratic wage shocks, credit constraints and absorbing retirement (DC-EGM)

The code also contains the `polyline.m` class which presents a set of tools for working with linearly interpolated functions, including the upper envelope algorithm.
The code also contains the _easy start implementation of EGM_ algorithm in just 13 lines of code.

### References
1. Christopher D. Carroll "[The method of endogenous gridpoints for solving dynamic stochastic optimization problems]
(http://www.sciencedirect.com/science/article/pii/S0165176505003368)" (Economics Letters, 2006)
2. Iskhakov, Jorgensen, Rust and Schjerning 
"[The Endogenous Grid Method for Discrete-Continuous Dynamic Choice Models with (or without) Taste Shocks]
(http://onlinelibrary.wiley.com/doi/10.3982/QE643/full)" (Quantitative Economics, 2017)

### Slides
Lecture notes from the ZICE2017 lecture on DC-EGM https://dl.dropboxusercontent.com/u/17240700/sync4web/dcegm_zice2017.pdf

### Installation and running
1. Make sure the files are in the Matlab work directory
2. Run `addpath('utils')` (this is done automatically in `run.m` script)
3. Run your script, or run `run.m` for examples

### minimal.m

The minimal implementation of the EGM algorithms for the stochastic consumption-savings lifecycle model with credit constraints is

```matlab
% Parameters
EXPN=10         % Number of quadrature points to calculate expectation
MMAX=10         % Maximum wealth
NM=100          % Number of grid points
TBAR=25         % Number of time periods
SIGMA=0.25      % Sigma parameter in logNormal distribution
Y=1             % Wage income
R=0.05          % Interest rate
DF=0.95         % Discount factor

% 13 lines EGM implementation
[quadp quadw]=quadpoints(EXPN,0,1);     % create quadrature notes and weights
quadstnorm=norminv(quadp,0,1);          % prepare quadrature points for calculation of expectations of Normal
savingsgrid=linspace(0,MMAX,NM);        % post-decision grid on savings
policy{TBAR}.w=[0 MMAX];                % terminal period wealth
policy{TBAR}.c=[0 MMAX];                % terminal period optimal consumption
for it=TBAR-1:-1:1                      % main backwards induction loop
 w1=Y+exp(quadstnorm*SIGMA)*(1+R)*savingsgrid;  % next period wealth (budget equation), matrix for all savings and all shocks
 c1=interp1(policy{it+1}.w,policy{it+1}.c,w1,'linear','extrap'); %next period optimal consumption
 rhs=quadw'*(1./c1);                    % RHS of the Euler equation (with log utility)
 policy{it}.c=[0 1./(DF*(1+R)*rhs)];    % current period optimal consumption rule
 policy{it}.w=[0 savingsgrid+policy{it}.c(2:end)]; % current period endogenous grid on wealth
end

% Plot the optimal policy functions
for it=TBAR:-1:1
  plot(policy{it}.w,policy{it}.c)
  hold all
end
set(gca,'XLim',[0 MMAX])
xlabel(gca,'Wealth')
ylabel(gca,'Optimal consumption')
title(gca,'Optimal consumption rules by age')
```

The solution of the problems is a set of policy function saved in `policy` structure.
<img src="https://cloud.githubusercontent.com/assets/2765768/21123659/2a404488-c12e-11e6-84ba-4a7ec5d5b212.png" width="75%"></img>

### Solution and simulations for the Phelps model with stochastic returns (EGM)
<img src="https://cloud.githubusercontent.com/assets/2765768/21123660/2a82b35e-c12e-11e6-8eb8-970079156afc.png" width="30%"></img>
<img src="https://cloud.githubusercontent.com/assets/2765768/21123661/2a960a44-c12e-11e6-95cf-6051158144ef.png" width="30%"></img>
<img src="https://cloud.githubusercontent.com/assets/2765768/21123663/2aa36112-c12e-11e6-8cea-bedb1cdcafe6.png" width="30%"></img>

### Retirement model: optimal consumption rules, value functions and probability to remain working (DC-EGM)

Note the kinks in the value function of the worker and discontinuities in the optimal consumption rules.

<img src="https://cloud.githubusercontent.com/assets/2765768/21123749/c02dc920-c12e-11e6-9a03-aeb57306c8f2.png" width="30%"></img>
<img src="https://cloud.githubusercontent.com/assets/2765768/21123747/c02cf310-c12e-11e6-8cf9-2522922038ab.png" width="30%"></img>
<img src="https://cloud.githubusercontent.com/assets/2765768/21123751/c0335372-c12e-11e6-8a48-3f88150c974f.png" width="30%"></img>

The kinks in the value function of the worker and discontinuities in the optimal consumption rules are smoothed with extreme value distributed taste shocks

<img src="https://cloud.githubusercontent.com/assets/2765768/21123750/c02f44ee-c12e-11e6-9609-e1c5fa854538.png" width="30%"></img>
<img src="https://cloud.githubusercontent.com/assets/2765768/21123748/c02d213c-c12e-11e6-9f25-ffccf51fe698.png" width="30%"></img>
<img src="https://cloud.githubusercontent.com/assets/2765768/21123746/c02befec-c12e-11e6-9276-90b829b42f65.png" width="30%"></img>

Simulated wealth and consumption profiles, and the histogram of simulated retirement ages

<img src="https://cloud.githubusercontent.com/assets/2765768/21123752/c056a84a-c12e-11e6-8145-1fa3ab764324.png" width="30%"></img>
<img src="https://cloud.githubusercontent.com/assets/2765768/21123755/c0588980-c12e-11e6-89af-f0322ded9653.png" width="30%"></img>
<img src="https://cloud.githubusercontent.com/assets/2765768/21123754/c0582ec2-c12e-11e6-9fb3-889ba50618e8.png" width="30%"></img> 


<!-- 
### Other public implementations of endogenous grid methods
 -->






