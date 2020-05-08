function [Ploss Tchanges Rchanges Q_accuracy] = compute_results(Xopt,t)
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results Keeptrack FCount;     
    %Changes systemdata according to run optimal power flow
    Systemdata.mpc.bus(24:end,4) = Xopt(18).';
    Systemdata.mpc.branch(1,9) = Xopt(19); %change tf ratio 
    Systemdata.mpc.branch(13,9) = Xopt(20);
    Systemdata.mpc.bus(2,CONSTANTS.BS) = Xopt(21);%Changes inductor
    Systemdata.mpc.bus(5,CONSTANTS.BS) = Xopt(22);%Changes capacitor
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