%%This function initialises the weights for the different constraint
%%violation factors and the objectives of the objective function.
function initialise_optimisation_weights()
global Optimisation

%Weights of constraint violation
Optimisation.p1 = 1;            %Penalty for voltage violation
Optimisation.p2 = 2;            %Penalty for Qref violation
Optimisation.p3 = 1;            %Penalty for power violation

%Weights of the OF
Optimisation.w1 = 1;            %Weight of Ploss
Optimisation.w2 = 2;            %Weight of the transformer tap switches cost
Optimisation.w3 = 10;            %Weight of the reactor cost
end