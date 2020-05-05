clear all;
close all;

%%load MATPOWER constants for convenience in the struct CONSTANTS
define_constants_struct();

%%surpress MATPOWER outputs
global mpopt CONSTANTS;
mpopt = mpoption('verbose',0,'out.all',-1);

%%variables containing the best solutions at all evaluated time instances
%%Xbest is a nxm matrix where n is the number of evaluated time instances
%%and m is the number of optimisation variables. Fbest is a vector of
%%length n which contains the fitness of set of variables in Xbest.
Ncases = 1;     %number of evaluated time instances
Nruns = 1;      %number of runs per case
Neval = 1e4;    %max allowed function evaluations

global Fbest Xbest; 

%setpoint at PCC given by TSO
global Qref;    
Qref.setpoint = 0; %in p.u. of baseMVA
Qref.tolerance = 1e-3;

mpc = test_sys41();
Xin = magic(5);
[F,Xout] = fitness_eval(Xin,mpc);