%%This function is used to compute the constraint violations of the system.
%%It returns a vector containing which constraints are violated ('1') and a
%%number indicating the total number of violations.
function [violation_vec, total_violations, composition] = compute_violation_constraints_v2()
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 

    %% voltage violations
    %%1 if violation at bus j
    
    %update slackbus voltage limits to the one corresponding to Qref
    slack = find(PFresults.bus(:,CONSTANTS.BUS_TYPE) == 3);
    index_slack = find(PFresults.gen(:,1) == slack);
    Qpcc = -1*PFresults.gen(index_slack,3)./PFresults.baseMVA;  
    vlimpcc = compute_vlimits(Qpcc);
    PFresults.bus(slack,CONSTANTS.VMAX:CONSTANTS.VMIN) = vlimpcc;
    
    %compute the violations of bus voltages
    violation_vbus_max_index = (PFresults.bus(:,CONSTANTS.VM) > PFresults.bus(:,CONSTANTS.VMAX));  %vmax
    violation_vbus_max_vec = PFresults.bus(violation_vbus_max_index,CONSTANTS.VM) - PFresults.bus(violation_vbus_max_index,CONSTANTS.VMAX);
    violation_vbus_max = (Optimisation.p1)*sum(violation_vbus_max_vec);
    
    violation_vbus_min_index = (PFresults.bus(:,CONSTANTS.VM) < PFresults.bus(:,CONSTANTS.VMIN));  %vmax
    violation_vbus_min_vec = PFresults.bus(violation_vbus_min_index,CONSTANTS.VMIN) - PFresults.bus(violation_vbus_min_index,CONSTANTS.VM);   
    violation_vbus_min = (Optimisation.p1)*sum(violation_vbus_min_vec);
    %% Compute Qref violation
    %%check if Q at PCC is near Qref within the range given by tolerance.
    %%1 if Qpcc is outside the dynamic limits calculated using
    %%qpcc_limits();
    if Qpcc > Qref.limits(2)
       violation_Qpcc = Optimisation.p2*(Qpcc - Qref.limits(2));
    elseif Qpcc < Qref.limits(1)
        violation_Qpcc = Optimisation.p2*(Qref.limits(1) - Qpcc);
    else
        violation_Qpcc = 0;   
    end
    %% line flow violations From
    %%1 if violation of current limit in a branch. The current limit is
    %%converted to an apparent power limit 'rate_A'
    
    sbranchFrom = sqrt(PFresults.branch(:,CONSTANTS.PF).^2 + PFresults.branch(:,CONSTANTS.QF).^2); %compute S through a branch in MVA
    violation_sbranchFrom_idx = sbranchFrom > PFresults.branch(:,CONSTANTS.RATE_A);
    violation_sbranchFrom_vec = sbranchFrom(violation_sbranchFrom_idx) - PFresults.branch(violation_sbranchFrom_idx,CONSTANTS.RATE_A);
    violation_sbranchFrom = (Optimisation.p3/2) * sum(violation_sbranchFrom_vec)/(Systemdata.baseMVA*Systemdata.Nbranch);

    %% line flow violations To
    %%1 if violation of current limit in a branch. The current limit is
    %%converted to an apparent power limit 'rate_A'
    
    sbranchTo = sqrt(PFresults.branch(:,CONSTANTS.PT).^2 + PFresults.branch(:,CONSTANTS.QT).^2); %compute S through a branch in MVA
    violation_sbranchTo_idx = sbranchTo > PFresults.branch(:,CONSTANTS.RATE_A);
    violation_sbranchTo_vec = sbranchTo(violation_sbranchTo_idx) - PFresults.branch(violation_sbranchTo_idx,CONSTANTS.RATE_A);
    violation_sbranchTo = (Optimisation.p3/2) * sum(violation_sbranchTo_vec)/(Systemdata.baseMVA*Systemdata.Nbranch);

    %% total violations
    
    violation_vec = [violation_vbus_max; violation_vbus_min; violation_Qpcc;...
        violation_sbranchFrom; violation_sbranchTo];
    composition = [length(violation_vbus_max_vec)+length(violation_vbus_min_vec),...
        1-(violation_Qpcc>0), length(violation_sbranchFrom_vec) + length(violation_sbranchTo_vec)];
    total_violations = sum(violation_vec);
end