%%This function is used to compute the constraint violations of the system.
%%It returns a vector containing which constraints are violated ('1') and a
%%number indicating the total number of violations.
function [violation_vec, total_violations, composition] = compute_violation_constraints()
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 

    %% voltage violations
    %%1 if violation at bus j
    
    %update slackbus voltage limits to the one corresponding to Qref
    slack = find(PFresults.bus(:,CONSTANTS.BUS_TYPE) == 3);
    index_slack = find(PFresults.gen(:,1) == slack);
    Qpcc = PFresults.gen(index_slack,3)./PFresults.baseMVA;  
    vlimpcc = compute_vlimits(Qpcc);
    PFresults.bus(slack,CONSTANTS.VMAX:CONSTANTS.VMIN) = vlimpcc;
    
    %compute the violations of bus voltages
    violation_vbus_max = Optimisation.p1*ones(Systemdata.Nbus,1) - (PFresults.bus(:,CONSTANTS.VM) <= PFresults.bus(:,CONSTANTS.VMAX));  %vmax
    violation_vbus_min = Optimisation.p1*ones(Systemdata.Nbus,1) - (PFresults.bus(:,CONSTANTS.VM) >= PFresults.bus(:,CONSTANTS.VMIN));  %vmax
 
    %% Compute Qref violation
    %%check if Q at PCC is near Qref within the range given by tolerance.
    %%1 if Qpcc is outside the dynamic limits calculated using
    %%qpcc_limits();
    violation_Qpcc = Optimisation.p2*((Qpcc > Qref.limits(2)) | (Qpcc < Qref.limits(1)));
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
    composition = [sum(violation_vbus_max+violation_vbus_min), violation_Qpcc, sum(violation_sbranchFrom+violation_sbranchTo)];
    total_violations = sum(violation_vec);
end