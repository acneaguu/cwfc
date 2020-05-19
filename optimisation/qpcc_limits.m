%%This function is used to compute the allowed deviation of Qpcc w.r.t. the
%%Qsetpoint requested by the TSO. In this function, it is assumed that the
%%gridcode of Qpcc is rectangular. Otherwise, Qmin and Qmax need to be
%%computed by taking the intersect of a shape (corresponding to the grid
%%code) and the active power output. 
function qpcc_limits()
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results FCount; 
%%grid code for rectangle
Qmin = -0.4;
Qmax = 0.33;

%%compute the limits
Qref.limits = [max([Qmin, Qref.setpoint-Qref.tolerance]), ...
    min([Qmax,Qref.setpoint+Qref.tolerance])];
end