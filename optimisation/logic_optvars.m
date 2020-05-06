function logic_optvars()
global Optimisation
Optimisation.tr_pos = logical([zeros(1,Optimisation.Nturbines +...
    Optimisation.Npv) ones(1,(Optimisation.Ntr)) zeros(1,Optimisation.Nr)]); 
                                            %logic vector with 1 on
                                            %transformer positions
Optimisation.r_pos = logical([zeros(1,Optimisation.Nturbines + ...
    Optimisation.Npv + Optimisation.Ntr) ones(1,Optimisation.Nr)]); 
                                            %logic vector with 1 on reactor
                                            %positions
Optimisation.discrete = or(Optimisation.tr_pos,Optimisation.r_pos);
                                            %logic vector which is 1 for
                                            %discrete variables
Optimisation.continuous = not(Optimisation.discrete);
                                            %logic vector with 1 on
                                            %continuous variables
end