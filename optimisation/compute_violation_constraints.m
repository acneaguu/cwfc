function [violation_vec, total_violations] = compute_violation_constraints()
global CONSTANTS Qref Systemdata PFresults Optimisation

    %% voltage violations
    %%1 if violation at bus j
    
    %update slackbus voltage limits to the one corresponding to Qref
    slack = find(PFresults.bus(:,CONSTANTS.BUS_TYPE) == 3);
    index_slack = find(PFresults.gen(:,1) == slack);
    Qpcc = PFresults.gen(index_slack,3)./PFresults.baseMVA;  %#ok<FNDSB>
    vlimpcc = compute_vlimits(Qpcc);
    PFresults.bus(slack,CONSTANTS.VMAX:CONSTANTS.VMIN) = vlimpcc;
    
    %compute the violations of bus voltages
    violation_vbus_max = Optimisation.p1*ones(Systemdata.Nbus,1) - (PFresults.bus(:,CONSTANTS.VM) <= PFresults.bus(:,CONSTANTS.VMAX));  %vmax
    violation_vbus_min = Optimisation.p1*ones(Systemdata.Nbus,1) - (PFresults.bus(:,CONSTANTS.VM) >= PFresults.bus(:,CONSTANTS.VMIN));  %vmax
 
    %% Compute Qref violation
    %%check if Q at PCC is near Qref within the range given by tolerance.
    %%If not, 'vQpcc' is 1
    
    violation_Qpcc = Optimisation.p2*(1 - (abs(Qpcc - Qref.setpoint) <= Qref.tolerance));
    %% line flow violations From
    %%1 if violation of current limit in a branch. The current limit is
    %%converted to an apparent power limit 'rate_A'
    
    sbranchFrom = sqrt(PFresults.branch(:,CONSTANTS.PF).^2 + PFresults.branch(:,CONSTANTS.QF).^2); %compute S through a branch in MVA
    violation_sbranchFrom = Optimisation.p3*ones(Systemdata.Nbranch,1) - (sbranchFrom <= PFresults.branch(:,CONSTANTS.RATE_A));

    %% line flow violations To
    %%1 if violation of current limit in a branch. The current limit is
    %%converted to an apparent power limit 'rate_A'
    
    sbranchTo = sqrt(PFresults.branch(:,CONSTANTS.PT).^2 + PFresults.branch(:,CONSTANTS.QT).^2); %compute S through a branch in MVA
    violation_sbranchTo = Optimisation.p3*ones(Systemdata.Nbranch,1) - (sbranchTo <= PFresults.branch(:,CONSTANTS.RATE_A));

    %% total violations
    
    violation_vec = [violation_vbus_max; violation_vbus_min; violation_Qpcc; violation_sbranchFrom; violation_sbranchTo];
    total_violations = sum(violation_vec);
end