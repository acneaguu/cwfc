clear all;
close all;
%%load MATPOWER constants for convenience in the struct CONSTANTS
define_constants_struct();
rng default  % For reproducibility (needed for PS algorithm)

%setpoint at PCC given by TSO
global Qref;    
Qref.setpoint = 0.0; %in p.u. of baseMVA
Qref.tolerance = 0.1;

%Optimisation containts the optimisation problem parameters
global Optimisation;
%Description of variables to optimise
Optimisation.Nturbines = 18;                %number of turbine strings
Optimisation.Npv = 0;                       %number of pv generator strings
Optimisation.Ntr = 0;                       %number of transformers with discrete tap positions
Optimisation.Nr = 0;                        %number of discrete reactors
Optimisation.Nvars = Optimisation.Nturbines + Optimisation.Npv + ...
    Optimisation.Ntr + Optimisation.Nr;     %number of optimisation variables
logic_optvars                               %generate logic vectors for different var indeces
initialise_systemdata(system_41());

%Optimisation settings
initialise_optimisation_options
Optimisation.Ncases = 1;        %number of evaluated time instances
Optimisation.Nruns = 20;         %number of runs per case
Optimisation.Neval = 1e4;       %max allowed function evaluations
global Keeptrack FCount;

%%Variables containing the best solutions at all evaluated optimisation
%%runs
%%Xbest is a nxm matrix where n is the number of evaluated runs
%%and m is the number of optimisation variables. Fbest is a vector of
%%length n which contains the fitness of set of variables in Xbest.
global Fbest Xbest Systemdata; 
Fbest = NaN * zeros(Optimisation.Nruns+1,1);
Xbest = NaN * zeros(Optimisation.Nruns+1,Optimisation.Nvars);
Xbest(Optimisation.discrete) = 1;

Xin = rand(1,Optimisation.Nvars);

%%parameters for GA
fun = @(X)fitness_eval(X,2);
lb = -1*ones(Optimisation.Nvars,1);
ub = 1*ones(Optimisation.Nvars,1);
options = optimoptions('ga', 'FunctionTolerance', 1e-9, ...
    'MaxStallGenerations',3);
plot = 0;

%%run optimisation
for i = 1:Optimisation.Nruns
FCount = 0;
X = ga(fun,Optimisation.Nvars,[],[],[],[],lb,ub,[],options);
Xbest(i+1,:) = X;
Fbest(i+1) = fitness_eval(X,i+1);

if plot == 1
    animated_plot_fitness(Keeptrack.SolBest,Keeptrack.FitBest)
end
end



