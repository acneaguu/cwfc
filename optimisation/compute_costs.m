function OF = compute_costs(PFresults,Xin)%computes value of the OF
global CONSTANTS Qref mpopt Systemdata Optimisation Xbest Fbest;
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
    for i = Optimisation.Nturbines:Optimisation.Nturbines+Optimisation.Ntr
        
    end
    %% Reactor
    
    
    
    OF = Optimisation.w1*Ploss_tot;
end