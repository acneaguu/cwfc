clear all;
close all;
%%load MATPOWER constants for convenience in the struct CONSTANTS
define_constants_struct();
rng default  % For reproducibility (needed for PS algorithm)

%setpoint at PCC given by TSO
global Qref;    
Qref.setpoint = 0.0; %in p.u. of baseMVA
Qref.tolerance = 0.05;

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
initialise_systemdata(system_41);

%Optimisation settings
initialise_optimisation_options
Optimisation.Ncases = 1;        %number of evaluated time instances
Optimisation.Nruns = 2;         %number of runs per case
Optimisation.Neval = 1e4;       %max allowed function evaluations
global Keeptrack FCount;

global Systemdata ; 

%Results struct consits of the results of each optimal powerflow
%%Variables containing the best solutions at all evaluated optimisation
%%runs
%%Xbest is a nxm matrix where n is the number of evaluated runs
%%and m is the number of optimisation variables. Fbest is a vector of
%%length n which contains the fitness of set of variables in Xbest.

global Results;
Results.Ploss = NaN * zeros(Optimisation.Nruns,1);
Results.tchanges = NaN * zeros(Optimisation.Nruns,1);
Results.rchanges = NaN * zeros(Optimisation.Nruns,1);
Results.Fbest = NaN * zeros(Optimisation.Nruns+1,1);
Results.Xbest = NaN * zeros(Optimisation.Nruns+1,Optimisation.Nvars);
Results.Xbest(Optimisation.discrete) = 1;

Xin = rand(1,Optimisation.Nvars);
%%parameters for GA
fun = @(X)fitness_eval(X,2);
lb = -1*ones(Optimisation.Nvars,1);
ub = 1*ones(Optimisation.Nvars,1);
algorithm = 1; %1 for ga, 2 for pso

switch algorithm
    case 1
    options = optimoptions('ga', 'FunctionTolerance', 1e-9, ...
    'MaxStallGenerations',3);
    case 2
    options=optimoptions('particleswarm','MaxIterations',10);
end
%options=optimoptions('particleswarm','FunctionTolerance',1e-9...
%   ,'MaxStallIterations',1e9,'MaxStallTime',10);
plot = 0;
savedata = 1;

%%run optimisation
for i = 1:Optimisation.Nruns
if i == 2 %for i = 1 you dont optimise for minimal power losses, for i = 2 you do
    Optimisation.w1 =1 ;
end
FCount = 0;
switch algorithm
    case 1
    X = ga(fun,Optimisation.Nvars,[],[],[],[],lb,ub,[],options);
    case 2
    X = particleswarm(fun,Optimisation.Nvars,lb,ub,options);
end
Results.Xbest(i+1,:) = X;
Results.Fbest(i+1) = fitness_eval(X,i+1);

[Results.Ploss(i), Results.tchanges(i), Results.rchanges(i)] = ...
    compute_results(X,i+1);

if plot == 1
    animated_plot_fitness(Keeptrack.SolBest,Keeptrack.FitBest);
end

end


if savedata == 1
    rundata = sprintf('Nruns=%3.1d_Nvars=%3.1d',Optimisation.Nruns,Optimisation.Nvars);
    namestr = strcat(rundata,'_',datestr(now,'dd-MM-yyyy HH-mm-ss'));
    save(namestr)
end



