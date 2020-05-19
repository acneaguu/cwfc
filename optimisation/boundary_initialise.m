function [lb, ub]= boundary_initialise(Qmin,Qmax)
%Initialises optimisation boundaries for system 13
%Qmin and Qmax consist of the Q boundaries of wtg and pv strings
global Optimisation Systemdata CONSTANTS;


tr_max = Systemdata.mpc.branch(Systemdata.trans,CONSTANTS.ANGMIN).';
tr_min = Systemdata.mpc.branch(Systemdata.trans,CONSTANTS.ANGMAX).';
r_max = 1; % 1 corresponds with connected
r_min = 0; % 0 corresponds with disconnected

lb = [Qmin , tr_min , r_min];
ub = [Qmax , tr_max , r_max];
end