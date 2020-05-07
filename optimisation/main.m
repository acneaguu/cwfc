clear all;
close all;
%YYOYOYOYO
%%ewaaaaaa
%%load MATPOWER constants for convenience in the struct CONSTANTS
define_constants_struct();
rng default  % For reproducibility

%setpoint at PCC given by TSO
global Qref;    
Qref.setpoint = 0.2; %in p.u. of baseMVA
Qref.tolerance = 0.1;

%Optimisation containts the optimisation problem parameters
global Optimisation;
%Description of variables to optimise
Optimisation.Nturbines = 13;                %number of turbine strings
Optimisation.Npv = 0;                       %number of pv generator strings
Optimisation.Ntr = 0;                       %number of transformers with discrete tap positions
Optimisation.Nr = 0;                        %number of discrete reactors
Optimisation.Nvars = Optimisation.Nturbines + Optimisation.Npv + ...
    Optimisation.Ntr + Optimisation.Nr;     %number of optimisation variables
logic_optvars                               %generate logic vectors for different var indeces
initialise_systemdata

%Optimisation settings
initialise_optimisation_options
Optimisation.Ncases = 1;        %number of evaluated time instances
Optimisation.Nruns = 1;         %number of runs per case
Optimisation.Neval = 1e4;       %max allowed function evaluations


%%variables containing the best solutions at all evaluated time instances
%%Xbest is a nxm matrix where n is the number of evaluated time instances
%%and m is the number of optimisation variables. Fbest is a vector of
%%length n which contains the fitness of set of variables in Xbest.
global Fbest Xbest Systemdata; 
Xbest = zeros(1,Optimisation.Nvars);
Xbest(Optimisation.discrete) = 1;

Xin = rand(1,Optimisation.Nvars);
[F,Xout] = fitness_eval(Xin,Systemdata.mpc,2);