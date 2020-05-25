clear all;
close all;
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
Optimisation.Ntr = 2;                       %number of transformers with discrete tap positions
Optimisation.Ntaps = [17;17];               %number of tap positions per transformer (must have dimension of Ntr)
Optimisation.Nr = 1;                        %number of discrete reactors
Optimisation.Nvars = Optimisation.Nturbines + Optimisation.Npv + ...
    Optimisation.Ntr + Optimisation.Nr;     %number of optimisation variables
Optimisation.which_discrete = [14:16];      %indeces of the discrete variables
% Optimisation.steps =[0.0168235 0.0168235 1];%steps of the discrete variables
logic_optvars();                            %Logic vectors for optimisation vector
initialise_systemdata(system_13_correctbase);
%initialise_systemdata(system_13_v2);

%%Optimisation run settings
initialise_optimisation_weights();  %sets the weights of the different 
                                    %constraints and objectives
Optimisation.Ncases = 10;            %number of evaluated time instances
Optimisation.Nruns = 10;            %number of runs per case
Optimisation.Neval = 10e3;           %max allowed function evaluations
Optimisation.Populationsize = 200;   %size of the population
Optimisation.algorithm = 4; %1 for ga, 2 for pso, 3 for cdeepso %4 for MVMO_SHM

Optimisation.print_progress = 1;    %Plots runs in command window
Optimisation.print_interval = 1000; %Interval of printed steps
Optimisation.print_pfresults = 0;   %Plots powerflow results of optimal solution

%%settings to plot and store the results of the optimisation
plot = 1;
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
Qref.tolerance = 1/14; %tolerance at Q = 0 MVar
        %compute the allowed range of Qpcc w.r.t. the setpoints

v = [3.5 3.5 3.5 3.5 3.5 4.5 4.5 4.5 4.5 4.5 7 7 7 7 7 15 15 15 15 15]';
cases(:,1) = v;
cases(:,2) = [repmat(Qref.setpoint,4,1)];


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
    for j = 2:Optimisation.Ncases+1
        %%update the casefile
        %%update boundaries lb/ub
        Optimisation.t = j;
        qpcc_limits(cases(j-1,2)); 
        initialise_results_struct(); %%initialise the Results struct with NaNs
        [Qmin, Qmax] = generate_case(cases(j-1,1)); %Input: windspeed
        [lb, ub]= boundary_initialise(Qmin, Qmax);
        for i = 1:Optimisation.Nruns
        % if i == 2 %for i = 2 you dont optimise for minimal power losses
        %     Optimisation.w1 =0 ;
        % end
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
            ,Results(j).extremeness_setpoints(i+1), Results(j).Qaccuracy(i+1)]...
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
        %%store the progress of FitBest of this iteration
        Results(j).Fit_progress(i+1,:) = Keeptrack.FitBest;
        Results(j).Violation_composition_progress(:,:,i+1) = Keeptrack.violation_composition;
        Results(j).runtime(i,1) = toc;
        fprintf('Case %2d, Run %2d: %2f seconds \n',j-1,i,Results(j).runtime(i,1));
        %%plot if desired
        if plot == 1
            animated_plot_fitness(Keeptrack.SolBest,Keeptrack.FitBest);
        end

        end
        
        %calculate best/worst/mean of Ploss
        MaxPloss = Systemdata.mpc.baseMVA;
        Results(j).Ploss_best = min(Results(j).Ploss);
        Results(j).Ploss_worst = max(Results(j).Ploss(Results(j).Ploss < MaxPloss));
        Results(j).Ploss_mean = mean(Results(j).Ploss(Results(j).Ploss < MaxPloss));
        Results(j).Times_converged = sum(Results(j).Ploss<MaxPloss);
        
        %save the best fitness and solution 
        best_index = find(Results(j).Fbest == min(Results(j).Fbest),1);
        Results(j).best_run_fitness = min(Results(j).Fbest);
        Results(j).best_run_solution = Results(j).Xbest(best_index,:);
        
        %compute the average runtime
        Results(j).avg_runtime = mean(Results(j).runtime(:,1));
    end
    %%save the result if desired
    if store_results == 1
        savedata
    end
% end
% end
% end
% end