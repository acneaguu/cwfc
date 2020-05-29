function [lb, ub]= boundary_initialise(Qmin_wtg,Qmax_wtg,Qmin_pv,Qmax_pv)
%Initialises optimisation boundaries for system 13
%Qmin and Qmax consist of the Q boundaries of wtg and pv strings
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 


tr_max = Systemdata.mpc.branch(Systemdata.trans,CONSTANTS.ANGMIN).';
tr_min = Systemdata.mpc.branch(Systemdata.trans,CONSTANTS.ANGMAX).';
r_max = 1; % 1 corresponds with connected
r_min = 0; % 0 corresponds with disconnected

lb = NaN*zeros(1,Optimisation.Nvars);
ub = NaN*zeros(1,Optimisation.Nvars);

lb(Optimisation.wtg_pos) = Qmin_wtg;
ub(Optimisation.wtg_pos) = Qmax_wtg;
lb(Optimisation.pvg_pos) = Qmin_pv;
ub(Optimisation.pvg_pos) = Qmax_pv;
lb(Optimisation.tr_pos) = tr_min;
ub(Optimisation.tr_pos) = tr_max;
lb(Optimisation.r_pos) = r_min;
ub(Optimisation.r_pos) = r_max;


end