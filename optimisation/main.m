clear all;
close all;
total_execution_time = tic;
%%load MATPOWER constants for convenience in the struct CONSTANTS
define_constants_struct();
%%For reproducibility (needed for PS algorithm)
rng default  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Optimisation problem specification and settings 
%%Optimisation containts the optimisation problem parameters
global Optimisation ff_par Systemdata;
%%Description of variables to optimise
Optimisation.Nturbines = 13;                %number of turbine strings
Optimisation.Npv = 0;                       %number of pv generator strings
Optimisation.Ntr = 2; %2;                   %number of transformers with discrete tap positions
Optimisation.Ntaps = [17;17];               %number of tap positions per transformer 
                                            %(must have dimension of Ntr and separate by ;)
Optimisation.Nr = 1; %1                     %number of discrete reactors
Optimisation.Nvars = Optimisation.Nturbines + Optimisation.Npv + ...
    Optimisation.Ntr + Optimisation.Nr;     %number of optimisation variables
Optimisation.which_discrete = [14:16];      %indeces of the discrete variables
% Optimisation.steps =[0.0168235 0.0168235 1];%steps of the discrete variables
logic_optvars();                            %Logic vectors for optimisation vector
initialise_systemdata(system_13_350MVA);    

%%Optimisation run settings
initialise_optimisation_weights();  %sets the weights of the different 
                                    %constraints and objectives
Optimisation.Ncases = 4;            %number of evaluated time instances
Optimisation.Nruns = 1;             %number of runs per case
Optimisation.Neval = 500*35;        %max allowed function evaluations
Optimisation.Populationsize = 35;   %size of the population
Optimisation.algorithm = 4;         %1 for ga, 2 for pso, 3 for cdeepso %4 for MVMO_SHM

Optimisation.print_progress = 1;    %Plots runs in command window
Optimisation.print_interval = 1000;  %Interval of printed steps
Optimisation.print_pfresults = 0;   %Plots powerflow results of optimal solution

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
Optimisation.t = 1;
initialise_results_struct();

%%Fitness evaluation function
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
%%setpoint at PCC given by TSO
global Qref;    
Qref.setpoint =  [-0.286; -0.143; 0; 0.143; 0.286]; %in p.u. of baseMVA
Qref.tolerance = 0.0339/2; %tolerance at Q = 0 MVar
% Qref.tolerance = 0.005;
        
%%define the testcase
%v = [7 12 4.5 4.5 4.5 4.5 4.5 5 5 5 5 5 7 7 7 7 12 12 12 12 15 15 15 15 15]';
%v = [7 7 7 7 7 15 15 15 15 15]';
% v = [4.5 4.5 4.5 4.5 4.5 5 5 5 5 5 7 7 7 7 7 12 12 12 12 12 15 15 15 15 15]';
v = [15 15 15 15 15]';
%v = [3.5 3.5 3.5 3.5 3.5 4.5 4.5 4.5 4.5 4.5]';
v = [15 15 15 15 15];
cases(:,1) = v;
cases(:,2) =repmat(Qref.setpoint,1,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fsmin = [0.2 0.35 0.5 1];
% fsmax = [2 5 10];
% ndimmin = [1 0.9 0.8];
% ndimmax = [1 0.5 0.3 0.1];
% global parameter
% for k = 1:length(fsmin)
% parameter.fs_factor_start = fsmin(k);
% for kk = 1:length(fsmax)
% parameter.fs_factor_end = fsmax(kk);
% for kkk = 1:length(ndimmin)
% parameter.n_random_ini = ndimmin(kkk);
% for kkkk = 1:length(ndimmax)
% parameter.n_random_last = ndimmax(kkkk);
% global parameter proc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Optimisation.w3 = 0.15;                              %Weight of the extremeness of Qstrings
w1 = 0:0.05:(1-Optimisation.w3);
%sweep over different weights
for k = 1:length(w1)
%timer for sweep
sweeptime = tic;
%update weights
Optimisation.w1 = w1(k);                            %Weight of Ploss
Optimisation.w2 = (1-Optimisation.w3)-w1(k);        %Weight of switching
                
%%run different cases
    for j = 2:Optimisation.Ncases+1
        
        %%set j for internal use
        Optimisation.t = j;
        
        %%initialise the Results struct with NaNs for each case
        initialise_results_struct(); 
        
        %%compute the allowed range of Qpcc w.r.t. the setpoints
        qpcc_limits(cases(j-1,2)); 
        
        %%compute the reactive power generation per string depending on the
        %%windspeed
        [Qmin, Qmax] = generate_case(cases(j-1,1));

        %%update boundaries lb/ub
        [lb, ub]= boundary_initialise(Qmin, Qmax,0,0);
        
        %%case duration timer
        start_case = tic;
        
        %%run a case multiple times
        for i = 1:Optimisation.Nruns
        tic;
        fprintf('************* Case %d, Run %d *************\n',j-1, i);

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
        Results(j).Xbest(i+1,:) = round_discrete_vars(X);
        switch Optimisation.algorithm
            case {1,2}
                Results(j).Fbest(i+1) = Keeptrack.FitBest(end);
            case {3,4}
                Results(j).Fbest(i+1) = gbestfit;
        end

        %%compute the Results(j) of the different OF parameters and Qpcc using the
        %%final solution and store them in results
        [Results(j).Ploss(i+1), Results(j).tchanges(i+1), Results(j).Reactors_on(i+1)...
            ,Results(j).extremeness_setpoints(i+1), Results(j).total_cost_per_run(i+1), Results(j).Qaccuracy(i+1)]...
            = compute_results(Results(j).Xbest(i+1,:),cases(j-1,2));

        %%initilise matrix with FitBest progress at each iteration
        if i == 1
            Results(j).Fit_progress = NaN * zeros(Optimisation.Nruns+1,FCount);
            Results(j).Violation_composition_progress = NaN * zeros(FCount,3,Optimisation.Nruns+1);
        elseif FCount > size(Results(j).Fit_progress,2)
            dis = FCount-size(Results(j).Fit_progress,2);
            Results(j).Fit_progress(:,end+1:FCount) = repmat(Results(j).Fit_progress(:,end),1,dis);
            Results(j).Violation_composition_progress(end+1:FCount,:,:) = ...
                 repmat(Results(j).Violation_composition_progress(end,:,:),dis,1,1);
        end
        
        %% RESULTS STRUCT USED FOR PERFORMANCE EVALUATION
        %%store the progress of FitBest of this iteration
        Results(j).Fit_progress(i+1,:) = Keeptrack.FitBest;
        Results(j).Violation_composition_progress(:,:,i+1) = Keeptrack.violation_composition;
        Results(j).runtime(i,1) = toc;
        
        %%print the runtime of a run
        fprintf('Case %2d, Run %2d: %2f seconds \n',j-1,i,Results(j).runtime(i,1));
        
        %%plot if desired
        if plot == 1
            animated_plot_fitness(Keeptrack.SolBest,Keeptrack.FitBest);
        end

        end
        
        %%calculate best/worst/mean of Ploss
        MaxPloss = Systemdata.mpc.baseMVA;
        Results(j).Ploss_best = min(Results(j).Ploss);
        Results(j).Ploss_worst = max(Results(j).Ploss(Results(j).Ploss < MaxPloss));
        Results(j).Ploss_mean = mean(Results(j).Ploss(Results(j).Ploss < MaxPloss));
        
        %%save the best fitness and solution 
        Results(j).Times_converged = sum(Results(j).Fbest<=1);
        best_index = find(Results(j).Fbest == min(Results(j).Fbest),1);
        Results(j).best_run_fitness = min(Results(j).Fbest);
        Results(j).best_run_solution = Results(j).Xbest(best_index,:);
        
        %%calculates consistency performance
        Results(j).avg_fitness = mean(Results(j).Fbest(2:end));
        Results(j).std_fitness = std(Results(j).Fbest(2:end));
        Results(j).std_solution = std(Results(j).Xbest(2:end,:));
        
        %%calculate cost per case
        Results(j).total_cost_per_case = mean(Results(j).total_cost_per_run(2:end));
        %%compute the average runtime
        Results(j).avg_runtime = mean(Results(j).runtime(:,1));
        Results(j).total_runtime = toc(start_case);
        
        %%print the total case runtime
        fprintf('Case %2d, Total Runtime: %2f seconds \n',j-1,Results(j).total_runtime);
    end
% end
% end
% end
% end

%%total costs of optimisation
for j = 2:Optimisation.Ncases+1
    total_cost = sum(Results(j).total_cost_per_case);
end

%%save different variables into a cell for comparison
Data{k}.Results = Results;
Data{k}.Optimisation = Optimisation;
Data{k}.total_costs = total_cost;
Data{k}.total_sweeptime = toc(sweeptime);

%%print sweep done
fprintf('*****************************************\n')
fprintf('Sweep %2d done!! Total sweeptime: %2f seconds\n',k,Data{k}.total_sweeptime)
fprintf('*****************************************\n')
end

%%save the result if desired
if store_results == 1
    savedata
end

%%save and print the total execution time
total_execution_time = toc(total_execution_time);
fprintf('Total Execution time: %2f seconds \n',total_execution_time);