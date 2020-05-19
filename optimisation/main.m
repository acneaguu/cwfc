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
Qref.setpoint =     0; %in p.u. of baseMVA
Qref.tolerance = 0.15;  %tolerance at Q = 0 MVar
qpcc_limits();         %compute the allowed range of Qpcc w.r.t. the setpoints


%%Optimisation containts the optimisation problem parameters
global Optimisation ff_par Systemdata;
%%Description of variables to optimise
Optimisation.Nturbines = 13;                %number of turbine strings
Optimisation.Npv = 0;                       %number of pv generator strings
Optimisation.Ntr = 2;                       %number of transformers with discrete tap positions
Optimisation.Ntaps = [17;17];               %number of tap positions per transformer (must have dimension of Ntr)
Optimisation.Nr = 1;                        %number of discrete reactors
Optimisation.Nvars = Optimisation.Nturbines + Optimisation.Npv + ...
    Optimisation.Ntr + Optimisation.Nr;     %number of optimisation variables
Optimisation.which_discrete = [14:16];%#ok<NBRAK> %indeces of the discrete variables
% Optimisation.steps =[0.0168235 0.0168235 1];%steps of the discrete variables
logic_optvars();                            %generate logic vectors for different var indeces
initialise_systemdata(system_13);

%Ones describe the bounds of optimisation variables
%lb = -30% of Pn (5MW), ub = 40% of Pn
% lb = [-2.5*ones(Optimisation.Nvars-4,1).' 0.851 0.87 -20 0];
% ub = [2.5*ones(Optimisation.Nvars-4,1).' 1.149 1.13 0 20];

%Q_wt_max = [21.2 18.55 19.15 10.9 22.4 19.15 12.2 19.6 22.4 13.248 19.6 19.6 19.6] ;
%Q_wt_min = -Q_wt_max;
Q_pv_max = [10.1 10.1 10.1 10.1];
Q_pv_min = -Q_pv_max;

Q_wt_max = 2.5*ones(1,Optimisation.Nturbines);
Q_wt_min = -Q_wt_max;
%Qmax and Qmin change depending on windspeed/solar irradiance
Qmax = [Q_wt_max ];
Qmin = [Q_wt_min ];
boundary_initialise(Qmin, Qmax);
lb = Optimisation.lb;
ub = Optimisation.ub;

%%Optimisation run settings
initialise_optimisation_weights();  %sets the weights of the different 
                                    %constraints and objectives
Optimisation.Ncases = 1;            %number of evaluated time instances
Optimisation.Nruns = 1;            %number of runs per case
Optimisation.Neval = 3.5e3;           %max allowed function evaluations
Optimisation.Populationsize = 200;   %size of the population
Optimisation.algorithm = 4; %1 for ga, 2 for pso, 3 for cdeepso %4 for MVMO_SHM

Optimisation.print_progress = 1;
Optimisation.print_pfresults = 0;
Optimisation.print_interval = 1000; %Prints interval

%%settings to plot and store the results of the optimisation
plot = 0;
store_results = 0;


%Results struct consits of the results of each optimal powerflow
%%variables containing the best solutions at all evaluated optimisation
%%runs (Fbest), a matrix containing the best solution at each optimisation
%%run (Xbest), the progress of the best fitness value of each run
%%(Fit_progress), the accuracy of Qpcc (Qaccuracy) and the values of the OF
%%paramers at each run (Ploss, tchanges and rchanges)

global Results;
initialise_results_struct%%initialise the Results struct with NaNs


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%variable indicated which case is considered. For now, it is case 2 i.e.
%%the case after the initalisation case. This value should change within a
%%loop

%%Fitness evaluation function
Optimisation.t = 2;
switch Optimisation.algorithm
    case {1,2,3}
    fun = @(X)fitness_eval(X);
    case 4
    fun = str2func('fitness_eval');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
    initialise_cdeepso(); %this function initialises the CDEEPSO settings
    
    case 4 
    initialise_mvmoshm(); %this function initialises the MVMO-SHM settings
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% run optimisation
global Keeptrack FCount;    %some global vars to keep track of the calls of 
                            %the fitness evaluation funtion 
                            
for i = 1:Optimisation.Nruns
% if i == 2 %for i = 2 you dont optimise for minimal power losses
%     Optimisation.w1 =0 ;
% end
tic;
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
        [gbestfit, X] = CDEEPSO_algorithm(fun,lb,ub);
    case 4
        [gbestfit, X] = mvmo_ceno(fun,lb,ub);
end

%%store the best solution and fitness of this run
Results.Xbest(i+1,:) = round_discrete_vars(X);
switch Optimisation.algorithm
    case {1,2}
        Results.Fbest(i+1) = Keeptrack.FitBest(end);
    case {3,4}
        Results.Fbest(i+1) = gbestfit;
end

   

%%compute the results of the different OF parameters and Qpcc using the
%%final solution and store them in results
[Results.Ploss(i+1), Results.tchanges(i+1), Results.Reactors_on(i+1),...
    Results.Qaccuracy(i+1)] = compute_results(Results.Xbest(i+1,:));

%%initilise matrix with FitBest progress at each iteration
if i == 1
    Results.Fit_progress = NaN * zeros(Optimisation.Nruns+1,FCount);
    Results.Violation_composition_progress = NaN * zeros(FCount,3,Optimisation.Nruns+1);
elseif FCount > size(Results.Fit_progress,2)
    dis = FCount-size(Results.Fit_progress,2);
    Results.Fit_progress(:,end+1:FCount) = repmat(Results.Fit_progress(:,end),1,dis);
    Results.Violation_composition_progress(end+1:FCount,:,:) = ...
         repmat(Results.Violation_composition_progress(end,:,:),dis,1,1);
end
%%store the progress of FitBest of this iteration
Results.Fit_progress(i+1,:) = Keeptrack.FitBest;
Results.Violation_composition_progress(:,:,i+1) = Keeptrack.violation_composition;
Results.runtime(i,1) = toc;
fprintf('Run %2d: %2f seconds \n',i,Results.runtime(i,1));
%%plot if desired
if plot == 1
    animated_plot_fitness(Keeptrack.SolBest,Keeptrack.FitBest);
end

end

MaxPloss = Systemdata.mpc.baseMVA;
Results.Ploss_best = min(Results.Ploss);
Results.Ploss_worst = max(Results.Ploss(Results.Ploss < MaxPloss));
Results.Ploss_mean = mean(Results.Ploss(Results.Ploss < MaxPloss));
Results.Times_converged = sum(Results.Ploss<MaxPloss);
Results.avg_runtime = mean(Results.Ploss(:,1));
%%save the result if desired
if store_results == 1
    savedata
end

