clear all;
close all;

%%load MATPOWER constants for convenience in the struct CONSTANTS
define_constants_struct();
rng default  % For reproducibility

%%surpress MATPOWER outputs
global mpopt CONSTANTS;
mpopt = mpoption('verbose',0,'out.all',-1);

%%a random comment appeared
%%another random comment

%setpoint at PCC given by TSO
global Qref;    
Qref.setpoint = 0; %in p.u. of baseMVA
Qref.tolerance = 1e-3;

%global struct which contains penalty values for the different constraints
global pen;
pen.p1 = 1; %Penalty for voltage violation
pen.p2 = 1; %Penalty for Qref violation
pen.p3 = 1; %Penalty for power violation

%Casedata consists of relevant optimisation problem parameters
global Casedata;
Casedata.mpc = test_sys41();
Casedata.Nbranch = size(Casedata.mpc.branch,1);
Casedata.Nbus = size(Casedata.mpc.bus,1);


%Optimisation containts the optimisation algorithm parameters
global Optimisation;
Optimisation.Ncases = 1;     %number of evaluated time instances
Optimisation.Nruns = 1;      %number of runs per case
Optimisation.Neval = 1e4;    %max allowed function evaluations


%%variables containing the best solutions at all evaluated time instances
%%Xbest is a nxm matrix where n is the number of evaluated time instances
%%and m is the number of optimisation variables. Fbest is a vector of
%%length n which contains the fitness of set of variables in Xbest.
global Fbest Xbest; 


Xin = magic(5);
[F,Xout] = fitness_eval(Xin,mpc);










