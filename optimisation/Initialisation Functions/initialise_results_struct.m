%%This function creates the Result struct and initialises the variables
%%with NaNs.
function initialise_results_struct
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 

%%total runs is nruns + 1 (init)
total_runs = Optimisation.Nruns;  

if Optimisation.t ==1
    Results(Optimisation.t).best_run_solution = ...
        NaN * zeros(1,Optimisation.Nvars);
    Results(Optimisation.t).best_run_solution(1,Optimisation.discrete) = ...
        [1.1530 1.1530 1];
else
    %%initialise the result structs
    %fitness and solution vector
    Results(Optimisation.t).Fbest = NaN * zeros(total_runs,1);
    Results(Optimisation.t).Xbest = NaN * zeros(total_runs,Optimisation.Nvars);

    %Ploss
    Results(Optimisation.t).Ploss = NaN * zeros(total_runs,1);
    Results(Optimisation.t).Ploss_best = NaN * zeros(total_runs,1);
    Results(Optimisation.t).Ploss_worst = NaN * zeros(total_runs,1);
    Results(Optimisation.t).Ploss_mean = NaN * zeros(total_runs,1);

    %transformer and reactor status
    Results(Optimisation.t).tchanges = NaN * zeros(total_runs,1);
    Results(Optimisation.t).Reactors_on = NaN * zeros(total_runs,1);
    Results(Optimisation.t).extremeness_setpoints = NaN * zeros(total_runs,1);

    %accuracy of Qpcc w.r.t Qref
    Results(Optimisation.t).Qaccuracy = NaN * zeros(total_runs,1);

    %times converged and average runtime
    Results(Optimisation.t).Times_converged = NaN * zeros(total_runs,1);
    Results(Optimisation.t).avg_runtime  = NaN * zeros(total_runs,1);
end
end