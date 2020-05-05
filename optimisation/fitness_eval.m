%%Authors: Jinpowpow & Koper
%%Date: 5 May 2020
%%Price: 100€

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%This function is used to determine the fitness of a given set of
%%solutions specified by 'Xin'. The fitness consists of two parts: the
%%objective function and the constraint penalty. The first part is the
%%objective function which is the main factor for the optimisation. This
%%term is relevant when a set of solutions is feasible i.e. do not violate
%%the set constraints. The constraint penalty should penalise constraint
%%violations. The more constraints are violated, the higher the penalty
%%should be and thus the fitness is worse. 

%%'Xin' can be both a vector (only one particle) or a matrix (where each
%%particle is represented by a different row.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%Constraints:
%%-DONE: vmin,vmaX
%%-DONE: iline -> sline (from/to)
%%-DONE (if assumption correct): stransformer -> probably done in sline



function [F,Xout] = fitness_eval(Xin,mpc)
global CONSTANTS Qref mpopt pen;
Xout = NaN * ones(size(Xin));
F = NaN * ones(size(Xin,1),1);
NXin = size(Xin,1);
Nbranch = size(mpc.branch,1);
Nbus = size(mpc.bus,1);

for np = 1:NXin
    %% run powerflow
    %%change casefile here
    PFresults = runpf(mpc,mpopt);

if PFresults.success == 1
    %------------------------------------------------------------------------
    %CONSTRAINTS:
    %% voltage violations
    %%1 if violation at bus j
    
    %update slackbus voltage limits to the one corresponding to Qref
    slack = find(PFresults.bus(:,CONSTANTS.BUS_TYPE) == 3);
    index_slack = find(PFresults.gen(:,1) == slack);
    Qpcc = PFresults.gen(index_slack,3)./PFresults.baseMVA;  %#ok<FNDSB>
    vlimpcc = compute_vlimits(Qpcc);
    PFresults.bus(slack,CONSTANTS.VMAX:CONSTANTS.VMIN) = vlimpcc;
    
    %compute the violations of bus voltages
    vio_vbus_max = pen.p1*ones(Nbus,1) - (PFresults.bus(:,CONSTANTS.VM) <= PFresults.bus(:,CONSTANTS.VMAX));  %vmax
    vio_vbus_min = pen.p1*ones(Nbus,1) - (PFresults.bus(:,CONSTANTS.VM) >= PFresults.bus(:,CONSTANTS.VMIN));  %vmax
 
    %% Compute Qref violation
    %%check if Q at PCC is near Qref within the range given by tolerance.
    %%If not, 'vQpcc' is 1
    
    vio_Qpcc = pen.p2*(1 - (abs(Qpcc - Qref.setpoint) <= Qref.tolerance));
    %% line flow violations From
    %%1 if violation of current limit in a branch. The current limit is
    %%converted to an apparent power limit 'rate_A'
    
    sbranchFrom = sqrt(PFresults.branch(:,CONSTANTS.PF).^2 + PFresults.branch(:,CONSTANTS.QF).^2); %compute S through a branch in MVA
    vio_sbranchFrom = pen.p3*ones(Nbranch,1) - (sbranchFrom <= PFresults.branch(:,CONSTANTS.RATE_A));

    %% line flow violations To
    %%1 if violation of current limit in a branch. The current limit is
    %%converted to an apparent power limit 'rate_A'
    
    sbranchTo = sqrt(PFresults.branch(:,CONSTANTS.PT).^2 + PFresults.branch(:,CONSTANTS.QT).^2); %compute S through a branch in MVA
    vio_sbranchTo = pen.p3*ones(Nbranch,1) - (sbranchTo <= PFresults.branch(:,CONSTANTS.RATE_A));

    %% total violations
    
    vio = [vio_vbus_max; vio_vbus_min; vio_Qpcc; vio_sbranchFrom; vio_sbranchTo];
    total_violations = sum(vio);
    checklimits(PFresults);
    %------------------------------------------------------------------------
    %COSTS
    %% Ploss
    %%branch losses
    [losses] = get_losses(PFresults);
    Ploss_branch = sum(real(losses));
    
    %%shunt losses (in the busses)
    Ploss_shunt = sum(PFresults.bus(:,CONSTANTS.VM) .^ 2 .* PFresults.bus(:,CONSTANTS.GS)); %%shunt absorption real
    Ploss_tot = Ploss_branch + Ploss_shunt;
    %sum(bus(nzsh, VM) .^ 2 .* bus(nzsh, BS))  %%shunt injection reactive
    
    %% Tap switches
    
    %% Reactor
else
    %%penalise unsuccesful run
    F = 1e50; %%give chancla to unsuccessful run
    
end
end
