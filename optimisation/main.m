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

%%Structure containing power system and optimization related information
%That is, 
global Systemdata;
Systemdata.mpc = test_sys41();
Systemdata.Nbranch = size(Systemdata.mpc.branch,1);
Systemdata.Nbus = size(Systemdata.mpc.bus,1);




%Optimisation containts the optimisation algorithm parameters
global Optimisation;

Optimisation.Ncases = 1;        %number of evaluated time instances
Optimisation.Nruns = 1;         %number of runs per case
Optimisation.Neval = 1e4;       %max allowed function evaluations
Optimisation.p1 = 1;            %Penalty for voltage violation
Optimisation.p2 = 1;            %Penalty for Qref violation
Optimisation.p3 = 1;            %Penalty for power violation
Optimisation.w1 = 1;            %Weights of the OF
Optimisation.w2 = 1;
Optimisation.w3 = 1;

Optimisation.Ncases = 1;                    %number of evaluated time instances
Optimisation.Nruns = 1;                     %number of runs per case
Optimisation.Neval = 1e4;                   %max allowed function evaluations

Optimisation.Nturbines = 13;                %number of turbine strings
Optimisation.Npv = 4;                       %number of pv generator strings
Optimisation.Ntr = 2;                       %number of transformers with discrete tap positions
Optimisation.Nr = 1;                        %number of discrete reactors
Optimisation.Nvars = Optimisation.Nturbines + Optimisation.Npv + ...
    Optimisation.Ntr + Optimisation.Nr;     %number of optimisation variables
Optimisation.discrete = logical([zeros(1,Optimisation.Nturbines + Optimisation.Npv)...
    ones(1,(Optimisation.Ntr + Optimisation.Nr))]); 
                                            %logic vector which is 1 for
                                            %discrete variables

logic_optvars()                             %generate logic vectors vor different var indeces

Optimisation.p1 = 1; %Penalty for voltage violation
Optimisation.p2 = 1; %Penalty for Qref violation
Optimisation.p3 = 1; %Penalty for power violation

%%variables containing the best solutions at all evaluated time instances
%%Xbest is a nxm matrix where n is the number of evaluated time instances
%%and m is the number of optimisation variables. Fbest is a vector of
%%length n which contains the fitness of set of variables in Xbest.
global Fbest Xbest; 
%Xbest = zeros(


Xin = magic(5);
[F,Xout] = fitness_eval(Xin,mpc);










