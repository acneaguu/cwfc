function initialise_optimisation_options()
global Optimisation

%Weights of constraint violation
Optimisation.p1 = 1;            %Penalty for voltage violation
Optimisation.p2 = 2;            %Penalty for Qref violation
Optimisation.p3 = 1;            %Penalty for power violation

%Weights of the OF
Optimisation.w1 = 1;            %Weight of Ploss
Optimisation.w2 = 0;            %Weight of the transformer tap switches cost
Optimisation.w3 = 0;            %Weight of the reactor cost
end