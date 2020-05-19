%%This function is used to compute the value of the OF of the current
%%solution Xin at t considering also past positions of the transformer taps
%%and the reactor connection.
function OF = compute_costs(Xin)
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 
    %% Ploss
    %%branch losses
    [losses] = get_losses(PFresults);
    Ploss_branch = sum(real(losses));
    
    %%shunt losses (in the busses)
    Ploss_shunt = sum(PFresults.bus(:,CONSTANTS.VM) .^ 2 .* PFresults.bus(:,CONSTANTS.GS)); %%shunt absorption real
    
    %%total losses
    Ploss_tot = Ploss_branch + Ploss_shunt;
    %sum(bus(nzsh, VM) .^ 2 .* bus(nzsh, BS))  %%shunt injection reactive
    %% Tap switches
    %tap changes in ratios
    tap_changes_ratio = abs(Xin(Optimisation.tr_pos)-Results.Xbest(Optimisation.t-1,Optimisation.tr_pos)); 
    
    %convert the tap changes from rations to tap positions
    tap_changes = sum(tap_changes_ratio./Systemdata.trstep); 
    %% Reactor
    reactor_changes = sum(Xin(Optimisation.r_pos));
    %sum(abs(Xin(Optimisation.r_pos) - Results.Xbest(Optimisation.t-1,Optimisation.r_pos))); %relative reactor changes
    
    %% Calculate OF
    OF = Optimisation.w1*Ploss_tot+Optimisation.w2*tap_changes+Optimisation.w3*reactor_changes;
end