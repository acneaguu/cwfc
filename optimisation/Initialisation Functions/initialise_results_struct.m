%%This function creates the Result struct and initialises the variables
%%with NaNs.
function initialise_results_struct
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 

%%total runs is nruns + 1 (init)
total_runs = Optimisation.Nruns +1;  

%%initialise the result structs
%fitness and solution vector
Results.Fbest = NaN * zeros(total_runs,1);
Results.Xbest = NaN * zeros(total_runs,Optimisation.Nvars);
Results.Xbest(1,Optimisation.discrete) = [1.1530 1.1530 1];

%Ploss
Results.Ploss = NaN * zeros(total_runs,1);
Results.Ploss_best = NaN * zeros(total_runs,1);
Results.Ploss_worst = NaN * zeros(total_runs,1);
Results.Ploss_mean = NaN * zeros(total_runs,1);

%transformer and reactor status
Results.tchanges = NaN * zeros(total_runs,1);
Results.Reactors_on = NaN * zeros(total_runs,1);

%accuracy of Qpcc w.r.t Qref
Results.Qaccuracy = NaN * zeros(total_runs,1);

%times converged and average runtime
Results.Times_converged = NaN * zeros(total_runs,1);
Results.avg_runtime  = NaN * zeros(total_runs,1);
end