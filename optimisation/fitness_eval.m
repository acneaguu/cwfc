%%Authors: Jinpowpow & Koper
%%Date: 5 May 2020
%%Price: 100€

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%This function is used to determine the fitness of a given set of
%%solutions specified by 'Xin'. The fitness consists of two parts: the
%%objective function and the constraint penalty. The first part is the
%%objective function which is the main factor for the optimisation. This
%%term is relevant when a set of solutions is feasible i.e. do not violate
%%the set constraints. The constraint penalty should penalise constraint
%%violations. The more constraints are violated, the higher the penalty
%%should be and thus the fitness is worse. 

%%'Xin' can be both a vector (only one particle) or a matrix (where each
%%particle is represented by a different row.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%Constraints:
%%-DONE: vmin,vmaX
%%-DONE: iline -> sline (from/to)
%%-DONE: stransformer -> done in sline 



function [F,Xout] = fitness_eval(Xin,mpc)
global mpopt Casedata Optimisation;
Xout = NaN * ones(size(Xin));
F = NaN * ones(size(Xin,1),1);
NXin = size(Xin,1);


for np = 1:NXin
    %% run powerflow
    %%round discrete Xin 
    Xin = round_discrete_vars(Xin,Optimisation.discrete);
    %%change casefile here
    PFresults = runpf(mpc,mpopt);

if PFresults.success == 1
    %------------------------------------------------------------------------
    %CONSTRAINTS:
    [violation_vec, total_violations] = compute_violation_constraints(PFresults);
    checklimits(PFresults);
    %------------------------------------------------------------------------
    OF = compute_costs(PFresults);
else
    %%penalise unsuccesful run
    F = 1e50; %%give chancla to unsuccessful run
    
end
end
