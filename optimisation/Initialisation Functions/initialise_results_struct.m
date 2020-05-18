%%This function creates the Result struct and initialises the variables
%%with NaNs.
function initialise_results_struct
global Results Optimisation

Results.Ploss = NaN * zeros(Optimisation.Nruns+1,1);
Results.tchanges = NaN * zeros(Optimisation.Nruns+1,1);
Results.rchanges = NaN * zeros(Optimisation.Nruns+1,1);
Results.Qaccuracy = NaN * zeros(Optimisation.Nruns+1,1);
Results.Fbest = NaN * zeros(Optimisation.Nruns+1,1);
Results.Xbest = NaN * zeros(Optimisation.Nruns+1,Optimisation.Nvars);
Results.Xbest(1,Optimisation.discrete) = [1.1530 1.1530 1];
end