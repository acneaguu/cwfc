%This function initialises the boundaries of the optimisation variables of
%system 13 Qmin and Qmax consist of the Q boundaries of wtg and pv strings
function [lb, ub]= boundary_initialise(Qmin_wtg,Qmax_wtg,Qmin_pv,Qmax_pv)
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 

%compute transformer and reactor boundaries. tr_xxx is empty when no
%transformer taps are controlled. 
tr_max = Systemdata.mpc.branch(Systemdata.trans,CONSTANTS.ANGMIN).';
tr_min = Systemdata.mpc.branch(Systemdata.trans,CONSTANTS.ANGMAX).';
r_max = 1; % 1 corresponds with connected
r_min = 0; % 0 corresponds with disconnected

%initialise boundary vector
lb = NaN*zeros(1,Optimisation.Nvars);
ub = NaN*zeros(1,Optimisation.Nvars);

%compute boundaries. If a controllable device is non-existent i.e. not
%controlled, lb/ub is not updated
lb(Optimisation.wtg_pos) = Qmin_wtg;
lb(Optimisation.pvg_pos) = Qmin_pv;
lb(Optimisation.tr_pos) = tr_min;
lb(Optimisation.r_pos) = r_min;
Systemdata.lb = lb;

ub(Optimisation.wtg_pos) = Qmax_wtg;
ub(Optimisation.pvg_pos) = Qmax_pv;
ub(Optimisation.tr_pos) = tr_max;
ub(Optimisation.r_pos) = r_max;
Systemdata.ub = ub;

end