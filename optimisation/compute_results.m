function [Ploss Tchanges Rchanges Q_accuracy] = compute_results(Xopt,t)
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results Keeptrack FCount;     
    %Changes systemdata according to optimal solution
    Systemdata.mpc.bus(24:end,4) = Xopt(Optimisation.continuous).';
    %Runs system once more with optimised variables
    PFresults = runpf(Systemdata.mpc,mpopt);
    
    %Computes resulting losses for optimal solution
    [losses] = get_losses(PFresults);
    Ploss_branch = sum(real(losses));
    Ploss_shunt = sum(PFresults.bus(:,CONSTANTS.VM) .^ 2 .* PFresults.bus(:,CONSTANTS.GS)); 
    Ploss = Ploss_branch + Ploss_shunt;
    
    %Computes resulting tap changes
    Tchanges = sum(abs(Xopt(Optimisation.tr_pos)-Results.Xbest(t-1,Optimisation.tr_pos)));
    
    %Computes resulting reactor changes
    Rchanges = sum(abs(Xopt(Optimisation.r_pos) - Results.Xbest(t-1,Optimisation.r_pos)));
    
    %Computes resulting |Qpcc-Qref|
    slack = find(PFresults.bus(:,CONSTANTS.BUS_TYPE) == 3);
    index_slack = find(PFresults.gen(:,1) == slack);
    Qpcc = PFresults.gen(index_slack,3)./PFresults.baseMVA;  
    Q_accuracy = abs(Qref.setpoint-Qpcc);
end