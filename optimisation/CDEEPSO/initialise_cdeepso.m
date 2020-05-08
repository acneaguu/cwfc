%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Leonel Carvalho, PhD (email: leonel.m.carvalho@inescporto.pt)
% Carolina Marcelino, PhD (email: carolimarc@cos.ufrj.br)
% April 02, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2018, Leonel Carvalho and Carolina Marcelino
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without
%modification, are permitted provided that the following conditions are
%met:
%
%    * Redistributions of source code must retain the above copyright
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright
%      notice, this list of conditions and the following disclaimer in
%      the documentation and/or other materials provided with the 
%      distribution
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
%POSSIBILITY OF SUCH DAMAGE.
%CITE "Solving security constrained optimal power flow problems: a hybrid
%evolutionary approach". Applied Intelligence, Springer, pp.: 1-19. 2018
%and
%"Applying C-DEEPSO to solve Large Scale Global Optimization Problems"
%Proc. IEEE on Congress on Evolutionary Computation (CEC), 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initialise_cdeepso
global ff_par CDEEPSO Optimisation Results;
% Dimension of optimization problem
ff_par.D = Optimisation.Nvars;
% INITIALIZE random number generator
seed = 1234;
rng( seed, 'twister'  );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET STRATEGIC PARAMETERS 
%Population size
CDEEPSO.popSize = 50;
%memory size 
CDEEPSO.memGBestSize = 5;
%strategyCDEEPSO 
%for mutation of velocity w.r.t. other individuals
% 1 -> Sg ; % 2 -> Pb ; % 3 -> Sg-rnd ; % 4 -> Pb-rnd; % 5 -> SgPb-rnd
CDEEPSO.strategyCDEEPSO = 5; 
% DE Strategy 
CDEEPSO.typeCDEEPSO = 3; % 2 -> Rand/1/bin; % 3 -> Best/1/bin
%Mutation rate 
CDEEPSO.mutationRate = 0.8;
%Communication rate 
CDEEPSO.communicationProbability = 0.4;
%generations
CDEEPSO.maxGen =50000;
CDEEPSO.maxGenWoChangeBest = 1000;
%% SET SIMULATION PARAMETERS
CDEEPSO.printConvergenceResults = 100; 
CDEEPSO.printConvergenceChart = 1; % 1 -> Chart ; 0 -> No Chart ;
%Maximun run 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Matrix results
Results.resultsCDEEPSO = NaN*ones( Optimisation.Nruns, Optimisation.Neval);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PRINT message
    fprintf('           C-DEEPSO 2018             \n');
    % PRINT simulation parameters
    fprintf('\nMax Gen: %d\n', CDEEPSO.maxGen);
    fprintf('Max Fit Evaluations: %d\n', Optimisation.Neval);
    fprintf('Max Gen With Equal Global Best: %d\n',CDEEPSO.maxGenWoChangeBest);
    fprintf('Population Size: %d\n', CDEEPSO.popSize);
    fprintf('Memory Size: %d\n', CDEEPSO.memGBestSize);
    fprintf('Mutation Rate: %.3f\n', CDEEPSO.mutationRate);
    fprintf('Communication Probability: %.3f\n\n', CDEEPSO.communicationProbability);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end