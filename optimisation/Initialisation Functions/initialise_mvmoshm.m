%By: Dr. Jose L. Rueda
%Date: 02.03.2012
%Edited: Alex Neagu & Jinhan Bai
%Date: 11/05/2020

%%This function is an edited version of an example made by Dr. J. Rueda.
%%This version is adapted to initialise the needed parameters for the
%%MVMO-SHM algorithm using the main. Call this function before running the
%%MVMO-SHM algorithm
function initialise_mvmoshm()
global ps parameter %%vars of MVMO-SHM
global Optimisation%%Vars for main


ps.D=Optimisation.Nvars; %Dimension of optimization problem (in this example 2 optimization variables)
args{1}=1; %Print in Matlab command window (1 means yes, 0 means No)
args{2}=1; %Printing step
args{3}=Optimisation.Neval; %Maximum function evaluations        
% =========================================================================

parameter.n_par=1;                          %Requested by competition. Check lines 16 and 32 of main file %45; %Number of particles  
parameter.n_tosave=4;                       %Archive size
parameter.fs_factor_start=1;                %Initial fs-factor 
parameter.fs_factor_end=2;                  %Final fs-factor
parameter.ratio_gute_max=0.3;               %Initial portion of good particles    
parameter.ratio_gute_min=0.3;               %Final portion of good particles
parameter.local_prob= 0;                    %ACHTUNG: Probability value between 0 and 1. Set to 0 to deactivate local search
parameter.n_random_ini =round(ps.D/1.0);    %initial number of variables selected for mutation ;  
parameter.n_random_last=round(ps.D/1.0 );   %final number of variables selected for mutation 
parameter.ratio_local = 0.09;

end