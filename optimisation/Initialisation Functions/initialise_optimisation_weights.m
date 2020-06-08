%%This function initialises the weights for the different constraint
%%violation factors and the objectives of the objective function.
function initialise_optimisation_weights()
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 

%Weights of constraint violation
Optimisation.p1 = 1;                %Penalty for voltage violation
Optimisation.p2 = 2;                %Penalty for Qref violation
Optimisation.p3 = 1;                %Penalty for power violation

%Weights of the OF
Optimisation.w1 = 1;                %Weight of Ploss
Optimisation.w2 = 0;                %Weight of transformer switches
Optimisation.w3 = 0;                %Weight of reactor switching
Optimisation.w4 = 0;                %Weight of the extremeness of Qstrings

%Cost of objectives
Optimisation.c1 = 80;               %cost in € of 1 MWh
Optimisation.c2 = 0.4;                %cost of a tap switch
Optimisation.c3 = 0.4;
Optimisation.c4 = 0.4/0.7;
Optimisation.timeinterval = 0.25;   %time interval per case; used for 
                                    %computation of the cost of power losses
end