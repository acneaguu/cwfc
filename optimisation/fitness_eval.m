%%Authors: Jinpowpow & Koper
%%Date: 5 May 2020
%%Price: 300€

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
%%particle is represented by a different row. 't' is used to specify the
%%current time case considered in order to compare the current transformer
%%and reactor positions to the previous ones in order to penalise a change
%%in these variables.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [F,OF,g,Xout] = fitness_eval(Xin)
global CONSTANTS mpopt Systemdata PFresults Optimisation Keeptrack FCount;
Xout = NaN * ones(size(Xin));
F = NaN * ones(size(Xin,1),1);
NXin = size(Xin,1);
for np = 1:NXin
    FCount = FCount+1;
    %% run powerflow
    %%round discrete Xin(i)
    Xout(np,:) = round_discrete_vars(Xin(np,:));
    
    %Change topology according to solutions
    update_casefile(Xout(np,:),1);
    
    %run pf on the system
    PFresults = runpf(Systemdata.mpc,mpopt);

if PFresults.success == 1
    %----------------------------------------------------------------------
    %CONSTRAINTS:
    [g, total_violations,composition] = compute_violation_constraints();
    %----------------------------------------------------------------------
    %Objective function:
    OF = compute_costs(Xin);
    %------------------------------------------------------------------------
    
    
    %consider only the OF if no violations and otherwise consider only the
    %constraint violations.
    if total_violations == 0
        F = OF;                    %feasible
    else
        F = total_violations*1e20; %infeasible
    end
else
    g = 100*ones(2*(Systemdata.Nbus+Systemdata.Nbranch)+1,1);
    composition = [2*Optimisation.p1*Systemdata.Nbus,Optimisation.p2,...
        2*Optimisation.p3*Systemdata.Nbranch];
    OF = 1e50;
    F = OF; %Big penalty if powerflow runs are unsuccesful
end

%Keeptrack.Fitness keeps track of fitness of every particle
Keeptrack.Fitness(FCount) = F; 
%Keeps track of the solutions corresponding to the fitnesses
Keeptrack.solution(FCount,:)= Xout(np,:);
%Keeps track of overall best fitnesses and solutions.
if FCount > 1
    if Keeptrack.Fitness(FCount) <= Keeptrack.FitBest(FCount-1)
        Keeptrack.FitBest(FCount) = Keeptrack.Fitness(FCount);
        Keeptrack.SolBest(FCount,:) = Keeptrack.solution(FCount,:); 
        Keeptrack.violation_composition(FCount,:) = composition;
    else
        Keeptrack.FitBest(FCount) = Keeptrack.FitBest(FCount-1);
        Keeptrack.SolBest(FCount,:) = Keeptrack.SolBest(FCount-1,:);
        Keeptrack.violation_composition(FCount,:) = ...
            Keeptrack.violation_composition(FCount-1,:);
    end
else
    Keeptrack.FitBest(FCount) = Keeptrack.Fitness(FCount);
    Keeptrack.SolBest(FCount,:) = Keeptrack.solution(FCount,:); 
    Keeptrack.violation_composition(FCount,:) = composition;
end
end


if Optimisation.algorithm == 4
global proc %#ok<TLEV>
    proc.i_eval = FCount;
    if proc.i_eval>=proc.n_eval 
        proc.finish=1;  
    end
end

if Optimisation.print_progress == 1 
    if (FCount == 1) || (FCount == Optimisation.Neval) || mod(FCount,Optimisation.print_interval) == 0
      fprintf('Neval: %7d,   fitness: %12.7E \n',...
          FCount, Keeptrack.FitBest(FCount))
    end
end
end
