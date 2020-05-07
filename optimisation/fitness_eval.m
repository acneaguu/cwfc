%%Authors: Jinpowpow & Koper
%%Date: 5 May 2020
%%Price: 200€

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



function [F,Xout] = fitness_eval(Xin,t)
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results Keeptrack FCount;
Xout = NaN * ones(size(Xin));
F = NaN * ones(size(Xin,1),1);
NXin = size(Xin,1);
for np = 1:NXin
    FCount = FCount+1;
    %% run powerflow
    %%round discrete Xin 
    Xout(np,:) = round_discrete_vars(Xin(np,:),Optimisation.discrete);
    Systemdata.mpc.bus(24:end,4) = Xout(np,Optimisation.continuous).';
%     Systemdata.mpc.branch(1,9) = Xout(np,19); change tf ratios
%     Systemdata.mpc.branch(13,9) = Xout(np,20);
    PFresults = runpf(Systemdata.mpc,mpopt);

if PFresults.success == 1
    %------------------------------------------------------------------------
    %CONSTRAINTS:
    [~, total_violations] = compute_violation_constraints();
    %checklimits(PFresults); %Prints violations in command window
    %------------------------------------------------------------------------
         OF = compute_costs(Xin,t);
    if total_violations == 0
        F = OF;                    %feasible
    else
        F = total_violations*1e20; %infeasible
    end
else
    F = 1e50; %Big penalty if powerflow runs are unsuccesful
end
%Keeptrack.Fitness keeps track of fitness of every particle
Keeptrack.Fitness(FCount) = F; 
%Keeps track of the solutions corresponding to the fitnesses
Keeptrack.solution(FCount,:)= Xout(np,:);
%Keeps track of overall best fitnesses and solutions
if FCount > 1
    if Keeptrack.Fitness(FCount) <= Keeptrack.FitBest(FCount-1)
        Keeptrack.FitBest(FCount) = Keeptrack.Fitness(FCount);
        Keeptrack.SolBest(FCount,:) = Keeptrack.solution(FCount,:); 
    else
        Keeptrack.FitBest(FCount) = Keeptrack.FitBest(FCount-1);
        Keeptrack.SolBest(FCount,:) = Keeptrack.SolBest(FCount-1,:);
    end
else
    Keeptrack.FitBest(FCount) = Keeptrack.Fitness(FCount);
    Keeptrack.SolBest(FCount,:) = Keeptrack.solution(FCount,:); 
end
end

end
