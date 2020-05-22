function[Q_wt_min, Q_wt_max] = generate_case(windspeed)
%%This function returns the correct reactive power string
%%boundaries for a given solar/windprofile
%%Furthermore it updates the casefile with the corresponding active power
%%outputs at the strings
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results FCount; 
[P_wtg, Q_wtg] = compute_pq_wtg(windspeed);
Q_wt_max = Q_wtg;
Q_wt_min = -Q_wt_max;
%Updates the active power outputs of the wtg strings
Systemdata.mpc.gen(Systemdata.wtg_pos,CONSTANTS.PG) = P_wtg;
end