%%This function creates the Result struct and initialises the variables
%%with NaNs.
function initialise_results_struct
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 

%%total runs is nruns + 1 (init)
total_runs = Optimisation.Nruns;  

if Optimisation.t ==1
    Results(Optimisation.t).best_run_solution = ...
        NaN * zeros(1,Optimisation.Nvars);
    
    %initialise first tap positions for Ntransformers
    if Optimisation.Ntr ~= 0
        Results(Optimisation.t).best_run_solution(1,Optimisation.tr_pos) = ...
        repmat(1.01,1,Optimisation.Ntr); %1.01 corresponds with the standard tap position
    end
    
    %initialise initial reactor status for Nreactors
    if Optimisation.Nr ~= 0
        Results(Optimisation.t).best_run_solution(1,Optimisation.r_pos) = ...
        ones(1,Optimisation.Nr); 
    end
else
    %%initialise the result structs
    %fitness and solution vector
    Results(Optimisation.t).Fbest = NaN * zeros(total_runs,1);
    Results(Optimisation.t).Xbest = NaN * zeros(total_runs,Optimisation.Nvars);

    %Ploss
    Results(Optimisation.t).Ploss = NaN * zeros(total_runs,1);
    Results(Optimisation.t).Ploss_best = NaN;
    Results(Optimisation.t).Ploss_worst = NaN;
    Results(Optimisation.t).Ploss_mean = NaN;

    %transformer and reactor status
    Results(Optimisation.t).Tap_changes = NaN * zeros(total_runs,1);
    Results(Optimisation.t).Reactors_changes = NaN * zeros(total_runs,1);
    Results(Optimisation.t).extremeness_setpoints = NaN * zeros(total_runs,1);
    
    %total cost of optimisation
    Results(Optimisation.t).total_cost_per_run = NaN * zeros(total_runs,1);

    %accuracy of Qpcc w.r.t Qref
    Results(Optimisation.t).Qaccuracy = NaN * zeros(total_runs,1);

    %times converged and average runtime
    Results(Optimisation.t).Times_converged = NaN * zeros(total_runs,1);
    Results(Optimisation.t).avg_runtime  = NaN * zeros(total_runs,1);
end
end