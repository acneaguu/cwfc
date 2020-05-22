%%This function is used to compute Ploss, the tap changes, the reactor
%%changes and the q accuracy for the last iteration. It actually  is a
%%modified version of fitness_eval and
%%compute_costs/compute_violation_constraints
function [Ploss, Tchanges, Reactor_changes, extremeness_setpoints,Q_accuracy] = compute_results(Xopt)
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results;     
    
    %Changes systemdata according to run optimal power flow
    update_casefile(Xopt,1);
    
    %Runs system once more with optimised variables
    PFresults = runpf(Systemdata.mpc,mpopt);
    
    %Computes resulting losses for optimal solution
    [losses] = get_losses(PFresults);
    Ploss_branch = sum(real(losses));
    Ploss_shunt = sum(PFresults.bus(:,CONSTANTS.VM) .^ 2 .* ...
        PFresults.bus(:,CONSTANTS.GS)); 
    Ploss = (Ploss_branch + Ploss_shunt)./Systemdata.mpc.baseMVA;
    
    %Computes resulting tap changes
    tap_changes_ratio = abs(Xopt(Optimisation.tr_pos)-...
        Results(Optimisation.t-1).best_run_solution(Optimisation.tr_pos));
    Tchanges = sum((tap_changes_ratio./Systemdata.trstep)); 
    
    %Computes resulting reactor changes
    %Reactors_on = sum(Xopt(Optimisation.r_pos));
    Reactor_changes = sum(abs(Xopt(Optimisation.r_pos) - ...
        Results(Optimisation.t-1).best_run_solution(Optimisation.r_pos))); %relative reactor changes
    
    %Computes resulting extremeness of the setpoints
    extremeness_setpoints = sum(abs(Xopt(Optimisation.wtg_pos | Optimisation.pvg_pos)));
    
    %Computes resulting |Qpcc-Qref|
    slack = find(PFresults.bus(:,CONSTANTS.BUS_TYPE) == 3);
    index_slack = find(PFresults.gen(:,1) == slack);
    Qpcc = PFresults.gen(index_slack,3)./PFresults.baseMVA;   
    Q_accuracy = abs(Qref.setpoint-Qpcc);
    if Optimisation.print_pfresults == 1
        printpf(PFresults);
        %checklimits(PFresults);
    end
end