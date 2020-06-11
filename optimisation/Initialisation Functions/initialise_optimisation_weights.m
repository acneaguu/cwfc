%%This function initialises the weights for the different constraint
%%violation factors and the objectives of the objective function.
function initialise_optimisation_weights()
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 

%Weights of constraint violation
Optimisation.p1 = 1;                %Penalty for voltage violation
Optimisation.p2 = 2;                %Penalty for Qref violation
Optimisation.p3 = 1;                %Penalty for power violation

%Weights of the OF
% Optimisation.w1 = 0.5;              %Weight of Ploss
% Optimisation.w2 = 0.4;                %Weight of transformer switches
% Optimisation.w3 = 0.05;             %Weight of reactor switching
% Optimisation.w4 = 0.05;             %Weight of the extremeness of Qstrings

Optimisation.w1 = 0.7;              %Weight of Ploss
Optimisation.w2 = 0.2;                %Weight of transformer switches
Optimisation.w3 = 0.05;             %Weight of reactor switching
Optimisation.w4 = 0.05;             %Weight of the extremeness of Qstrings

%Cost of objectives
Optimisation.timeinterval = 0.25;   %time interval per case; used for 
                                    %computation of the cost of power losses
Optimisation.c1 = 80;               %cost in € of 1 MWh
Optimisation.c2 = 0.1;              %cost of a tap switch (equal to cost of 5kW per 15 min)
Optimisation.c3 = 0.1;              %cost of a reactor switch (equal to cost of 5kW per 15 min)
Optimisation.c4 = 0.1/0.7;          %cost of distance of Qsetpoints 
                                    %(0.7 mean is equal to cost of 5kW per 15 min)

end