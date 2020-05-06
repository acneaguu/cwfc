function OF = compute_costs(Xin,t)%computes value of the OF
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Xbest Fbest;
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
    tap_changes = sum(abs(Xin(Optimisation.tr_pos)-Xbest(t-1,Optimisation.tr_pos)));
    
    %% Reactor
    reactor_changes = sum(abs(Xin(Optimisation.r_pos) - Xbest(t-1,Optimisation.r_pos)));
    
    OF = Optimisation.w1*Ploss_tot+Optimisation.w2*tap_changes+Optimisation.w3*reactor_changes;
end