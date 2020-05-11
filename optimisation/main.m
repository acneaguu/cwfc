clear all;
close all;
%%load MATPOWER constants for convenience in the struct CONSTANTS
define_constants_struct();
%%For reproducibility (needed for PS algorithm)
rng default  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Optimisation problem specification and settings 
%%setpoint at PCC given by TSO
global Qref;    
Qref.setpoint = -0.33; %in p.u. of baseMVA
Qref.tolerance = 0.05;

%%Optimisation containts the optimisation problem parameters
global Optimisation ff_par;
%%Description of variables to optimise
Optimisation.Nturbines = 22;                %number of turbine strings
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
Optimisation.Nruns = 1;         %number of runs per case
Optimisation.Neval = 1e4;       %max allowed function evaluations
global Keeptrack FCount;

%%Fitness evaluation function
Optimisation.t = 2;
fun = @(X)fitness_eval(X,Optimisation.t);

global Results;
Results.Ploss = NaN * zeros(Optimisation.Nruns,1);
Results.tchanges = NaN * zeros(Optimisation.Nruns,1);
Results.rchanges = NaN * zeros(Optimisation.Nruns,1);
Results.Qaccuracy = NaN * zeros(Optimisation.Nruns,1);
Results.Fbest = NaN * zeros(Optimisation.Nruns+1,1);
Results.Xbest = NaN * zeros(Optimisation.Nruns+1,Optimisation.Nvars);
Results.Xbest(Optimisation.discrete) = 1;

Xin = rand(1,Optimisation.Nvars);
%%parameters for GA
fun = @(X)fitness_eval(X,2);

%Ones describe the bounds of WTG Q's
lb = [-2.5*ones(Optimisation.Nvars-4,1).' 0.851 0.87 -20 0];
ub = [2.5*ones(Optimisation.Nvars-4,1).' 1.149 1.13 0 20];
Optimisation.algorithm = 2; %1 for ga, 2 for pso

%%Optimisation run settings
initialise_optimisation_options     %sets the weights of the different 
                                    %constraints and objectives
Optimisation.Ncases = 1;            %number of evaluated time instances
Optimisation.Nruns = 1;             %number of runs per case
Optimisation.Neval = 1e5;           %max allowed function evaluations
Optimisation.Populationsize = 200;   %size of the population
Optimisation.algorithm = 2; %1 for ga, 2 for pso, 3 for cdeepso

%%settings to plot and store the results of the optimisation
plot = 0;
store_results = 0;

%%parameters for the different algorithms
switch Optimisation.algorithm
    case 1
    options = optimoptions('ga', 'FunctionTolerance', 1e-9, ...
    'MaxGenerations',Optimisation.Neval/Optimisation.Populationsize,...
    'PopulationSize',Optimisation.Populationsize);
    case 2
    options=optimoptions('particleswarm','MaxIterations',...
        Optimisation.Neval,'SwarmSize',Optimisation.Populationsize);
    case 3
    initialise_cdeepso %this function initialises the CDEEPSO settings

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Results struct consits of the results of each optimal powerflow
%%variables containing the best solutions at all evaluated optimisation
%%runs (Fbest), a matrix containing the best solution at each optimisation
%%run (Xbest), the progress of the best fitness value of each run
%%(Fit_progess), the accuracy of Qpcc (Qaccuracy) and the values of the OF
%%paramers at each run (Ploss, tchanges and rchanges)

global Results;
initialise_results_struct%%initialise the Results struct with NaNs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%variable indicated which case is considered. For now, it is case 2 i.e.
%%the case after the initalisation case. This value should change within a
%%loop
%%Optimisation.t = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% run optimisation
global Keeptrack FCount;    %some global vars to keep track of the calls of 
                            %the fitness evaluation funtion 
                            
for i = 1:Optimisation.Nruns
% if i == 2 %for i = 2 you dont optimise for minimal power losses
%     Optimisation.w1 =0 ;
% end
fprintf('************* Run %d *************\n', i);

%%reinitialise fitness evaluation counter
FCount = 0;

%%case of the different algorithms
switch Optimisation.algorithm
    case 1
    X = ga(fun,Optimisation.Nvars,[],[],[],[],lb,ub,[],options);
    case 2
    X = particleswarm(fun,Optimisation.Nvars,lb,ub,options);
    case 3
    ff_par.fitEval = 0;
    ff_par.bestFitEval = 0;
    [ gbestfit, X ] = CDEEPSO_algorithm(fun,lb,ub);
end

%%store the best solution and fitness of this run
Results.Xbest(i+1,:) = X;
switch Optimisation.algorithm
    case {1,2}
        Results.Fbest(i+1) = fitness_eval(X,i+1);
    case 3
        Results.Fbest(i+1) = gbestfit;
end

%%compute the results of the different OF parameters and Qpcc using the
%%final solution and store them in results
[Results.Ploss(i+1), Results.tchanges(i+1), Results.rchanges(i+1),...
    Results.Qaccuracy(i+1)] = compute_results(X,i+1);

%%initilise matrix with FitBest progress at each iteration
if i == 1
    Results.Fit_progress = NaN * zeros(Optimisation.Nruns+1,FCount);
end
%%store the progress of FitBest of this iteration
Results.Fit_progress(i+1,:) = Keeptrack.FitBest;


%%plot if desired
if plot == 1
    animated_plot_fitness(Keeptrack.SolBest,Keeptrack.FitBest);
end
end

%%save the result if desired
if store_results == 1
    savedata
end
