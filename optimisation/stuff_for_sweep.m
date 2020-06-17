%%main stuff for sweep


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fsmin = [0.2 0.35 0.5 1];
% fsmax = [2 5 10];
% ndimmin = [1 0.9 0.8];
% ndimmax = [1 0.5 0.3 0.1];
% global parameter
% for k = 1:length(fsmin)
% parameter.fs_factor_start = fsmin(k);
% for kk = 1:length(fsmax)
% parameter.fs_factor_end = fsmax(kk);
% for kkk = 1:length(ndimmin)
% parameter.n_random_ini = ndimmin(kkk);
% for kkkk = 1:length(ndimmax)
% parameter.n_random_last = ndimmax(kkkk);
% Populationsize = [1 5 10 20 35 50];
% global parameter proc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimisation.w3 = 0.05;
% Optimisation.w4 = 0.15;
% w1 = 0:0.05:(1-Optimisation.w3-Optimisation.w4);
% 
% w3 = 0:0.05:0.2;
% w4 = 0:0.05:0.2;
% 
% %sweep over different weights
% for k = 1:length(w3)
% %timer for sweep
% sweeptime = tic;
% %update weights
% % Optimisation.w1 = w1(k);        %Weight of Ploss
% % Optimisation.w2 = (1-Optimisation.w3-Optimisation.w4)-w1(k);        %Weight of switching
% 
% Optimisation.w3 = w3(k);
% Optimisation.w4 = w4(k);
% Optimisation.w1 = (1-Optimisation.w3-Optimisation.w4)/2;
% Optimisation.w2 = (1-Optimisation.w3-Optimisation.w4)/2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%