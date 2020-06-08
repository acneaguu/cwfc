%%This function is used to compute the value of the OF of the current
%%solution Xin at t considering also past positions of the transformer taps
%%and the reactor connection.

%%THIS VERSION IS USED FOR THE DETERMINATION OF THE WEIGHTS 
%% IN THIS VERSION THE OBJECTIVES ARE IN EURO's €
function OF = compute_costs_v2(Xin)
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 
    
    %% Ploss
    %%branch losses
    [losses] = get_losses(PFresults);
    Ploss_branch = sum(real(losses));
    
    %%shunt losses (in the busses)
    Ploss_shunt = sum(PFresults.bus(:,CONSTANTS.VM) .^ 2 .* PFresults.bus(:,CONSTANTS.GS)); %%shunt absorption real
    
    %%total losses 
    %Assume 8 cents/kwh = 80 euro/MWh
    Ploss_tot = (Ploss_branch + Ploss_shunt)*Optimisation.c1 * Optimisation.timeinterval;
    %sum(bus(nzsh, VM) .^ 2 .* bus(nzsh, BS))  %%shunt injection reactive
    %% Tap switches
    %only compute tap switch costs when transformer taps are controlled
    %Assume  0.40 euro / tapswitch such hat 1 switch = 5kWh
    if Optimisation.Ntr ~= 0
        %tap changes in ratios
        tap_changes_ratio = abs(Xin(Optimisation.tr_pos)-Results(Optimisation.t-1).best_run_solution(Optimisation.tr_pos));
    
        %convert the tap changes from rations to tap positions
        tap_changes = sum((tap_changes_ratio./Systemdata.trstep))*Optimisation.c2;
    else
        tap_changes = 0;
    end
    %% Reactor
    %only compute reactor costs when reactors are controlled
    %Assume 0.40 euro/reactor switch such that 1 switch = 5 kWh
    if Optimisation.Nr ~= 0
    %reactor_changes = sum(Xin(Optimisation.r_pos));
        reactor_changes = Optimisation.c3*sum(abs(Xin(Optimisation.r_pos) - ...
        Results(Optimisation.t-1).best_run_solution(Optimisation.r_pos))); %relative reactor changes
    else
        reactor_changes = 0;    
    end
    %% extremeness of the setpoints
    %Assume 0.4 euro/0.7 mean reactive power distance s.t. 0.7 mean
    %distance = 5 kWh
    extremeness_setpoints = sum(abs(Xin(Optimisation.wtg_pos | Optimisation.pvg_pos))...
    /Systemdata.ub(Optimisation.wtg_pos | Optimisation.pvg_pos));
    extremeness_setpoints = (extremeness_setpoints/(Optimisation.Nturbines+Optimisation.Npv))*Optimisation.c4;
    %% Calculate OF
    OF = Optimisation.w1*Ploss_tot+Optimisation.w2*tap_changes+...
        Optimisation.w3*reactor_changes + Optimisation.w4*extremeness_setpoints;
end