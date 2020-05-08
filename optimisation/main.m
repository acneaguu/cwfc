clear all;
close all;
%%load MATPOWER constants for convenience in the struct CONSTANTS
define_constants_struct();
rng default  % For reproducibility (needed for PS algorithm)

%setpoint at PCC given by TSO
global Qref;    
Qref.setpoint = -0.33; %in p.u. of baseMVA
Qref.tolerance = 0.05;

%Optimisation containts the optimisation problem parameters
global Optimisation ff_par CDEEPSO;
%Description of variables to optimise
Optimisation.Nturbines = 22;                %number of turbine strings
Optimisation.Npv = 0;                       %number of pv generator strings
Optimisation.Ntr = 0;                       %number of transformers with discrete tap positions
Optimisation.Nr = 0;                        %number of discrete reactors
Optimisation.Nvars = Optimisation.Nturbines + Optimisation.Npv + ...
    Optimisation.Ntr + Optimisation.Nr;     %number of optimisation variables
logic_optvars                               %generate logic vectors for different var indeces

global Systemdata ; 
initialise_systemdata(system_41);

%Optimisation settings
initialise_optimisation_options
Optimisation.Ncases = 1;            %number of evaluated time instances
Optimisation.Nruns = 1;             %number of runs per case
Optimisation.Neval = 1e5;           %max allowed function evaluations
Optimisation.Populationsize = 50;   %size of the population for GA/
global Keeptrack FCount;



%Results struct consits of the results of each optimal powerflow
%%Variables containing the best solutions at all evaluated optimisation
%%runs
%%Xbest is a nxm matrix where n is the number of evaluated runs
%%and m is the number of optimisation variables. Fbest is a vector of
%%length n which contains the fitness of set of variables in Xbest.

global Results;
Results.Ploss = NaN * zeros(Optimisation.Nruns+1,1);
Results.tchanges = NaN * zeros(Optimisation.Nruns+1,1);
Results.rchanges = NaN * zeros(Optimisation.Nruns+1,1);
Results.Qaccuracy = NaN * zeros(Optimisation.Nruns+1,1);
Results.Fbest = NaN * zeros(Optimisation.Nruns+1,1);
Results.Xbest = NaN * zeros(Optimisation.Nruns+1,Optimisation.Nvars);
Results.Xbest(Optimisation.discrete) = 1;
Results.Fit_progress = NaN * zeros(Optimisation.Nruns+1,Optimisation.Neval);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%variable indicated which case is considered. For now, it is case 2 i.e.
%%the case after the initalisation case. This value should change within a
%%loop
Optimisation.t = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%parameters for GA

fun = @(X)fitness_eval(X,Optimisation.t);
lb = [-1*ones(Optimisation.Nvars-4,1).' 0.851 0.87 -100 0];
ub = [1*ones(Optimisation.Nvars-4,1).' 1.149 1.13 0 100];
Optimisation.algorithm = 3; %1 for ga, 2 for pso, 3 for cdeepso

switch Optimisation.algorithm
    case 1
    options = optimoptions('ga', 'FunctionTolerance', 1e-9, ...
    'MaxGenerations',Optimisation.Neval/Optimisation.Populationsize,...
    'PopulationSize',Optimisation.Populationsize);
    case 2
    options=optimoptions('particleswarm','MaxIterations',...
        Optimisation.Neval,'SwarmSize',Optimisation.Populationsize);
    case 3
    initialise_cdeepso;
end
%options=optimoptions('particleswarm','FunctionTolerance',1e-9...
%   ,'MaxStallIterations',1e9,'MaxStallTime',10);
plot = 0;
store_results = 0;

%%run optimisation
for i = 1:Optimisation.Nruns
% if i == 2 %for i = 2 you dont optimise for minimal power losses
%     Optimisation.w1 =0 ;
% end
fprintf('************* Run %d *************\n', i);
FCount = 0;
switch Optimisation.algorithm
    case 1
    X = ga(fun,Optimisation.Nvars,[],[],[],[],lb,ub,[],options);
    case 2
    X = particleswarm(fun,Optimisation.Nvars,lb,ub,options);
    case 3
    ff_par.fitEval = 0;
    ff_par.bestFitEval = 0;
%     ff_par.memNumFitEval = zeros( 1, Optimisation.Neval );
%     ff_par.memFitEval = zeros( 1, Optimisation.Neval);
    [ gbestfit, X ] = CDEEPSO_algorithm(fun,lb,ub);
%     ff_par.memNumFitEval = ff_par.memNumFitEval( 1:Optimisation.Neval );
%     ff_par.memFitEval = ff_par.memFitEval( 1:Optimisation.Neval );
%     Results.resultsCDEEPSO(i+1,:) = ff_par.memFitEval;
    
end

Results.Xbest(i+1,:) = X;
switch Optimisation.algorithm
    case 1 || 2
        Results.Fbest(i+1) = fitness_eval(X,i+1);
    case 3
        Results.Fbest(i+1) = gbestfit;
end

[Results.Ploss(i+1), Results.tchanges(i+1), Results.rchanges(i+1),Results.Qaccuracy(i+1)] = ...
    compute_results(X,i+1);
Results.Fit_progress(i+1,:) = Keeptrack.FitBest;
if plot == 1
    animated_plot_fitness(Keeptrack.SolBest,Keeptrack.FitBest);
end

end

if store_results == 1
    savedata
end

