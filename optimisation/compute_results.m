%%This function is used to compute Ploss, the tap changes, the reactor
%%changes and the q accuracy for the last iteration. It actually  is a
%%modified version of fitness_eval and
%%compute_costs/compute_violation_constraints
function [Ploss, Tchanges, Rchanges, Q_accuracy] = compute_results(Xopt)
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results;     
    
    %Round off before updating the case file because kk zionisten
    Xopt = round_discrete_vars(Xopt,Optimisation.discrete,Optimisation.discrete_steps);
    
    %Changes systemdata according to run optimal power flow
    update_casefile(Xopt,1);
    
    %Runs system once more with optimised variables
    PFresults = runpf(Systemdata.mpc,mpopt);
    
    %Computes resulting losses for optimal solution
    [losses] = get_losses(PFresults);
    Ploss_branch = sum(real(losses));
    Ploss_shunt = sum(PFresults.bus(:,CONSTANTS.VM) .^ 2 .* PFresults.bus(:,CONSTANTS.GS)); 
    Ploss = Ploss_branch + Ploss_shunt;
    
    %Computes resulting tap changes
    Tchanges = sum(abs(Xopt(Optimisation.tr_pos)-Results.Xbest(Optimisation.t-1,Optimisation.tr_pos)));
    
    %Computes resulting reactor changes
    Rchanges = sum(abs(Xopt(Optimisation.r_pos) - Results.Xbest(Optimisation.t-1,Optimisation.r_pos)));
    
    %Computes resulting |Qpcc-Qref|
    slack = find(PFresults.bus(:,CONSTANTS.BUS_TYPE) == 3);
    index_slack = find(PFresults.gen(:,1) == slack);
    Qpcc = PFresults.gen(index_slack,3)./PFresults.baseMVA;   %#ok<FNDSB>
    Q_accuracy = abs(Qref.setpoint-Qpcc);
    
end