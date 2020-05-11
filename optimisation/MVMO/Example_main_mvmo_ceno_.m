%**************************************************************************
%                  MVMO-based applications: Example 1
%**************************************************************************
%By: Dr. Jose L. Rueda
%Date: 02.03.2012

close all
clear all
clc

% =========================================================================
%                         Setting global variables 
% =========================================================================
% global parameter
% global printff sn
global proc ps
% =========================================================================


% =========================================================================
%                             Define MVMO parameters
% =========================================================================
ps.D=2; %Dimension of optimization problem (in this example 2 optimization variables)
ps.x_min = -2.048*ones(1,ps.D); %row vector
ps.x_max = 2.048*ones(1,ps.D); %row vector

algorithm_name='mvmo_ceno'; %For function hanlde of MVMO
algorithm_hd=str2func(algorithm_name); %Function hanlde of MVMO
of_apg_hd=str2func('test_func_forBAP'); %Function hanlde of m-file for obj function calculation
args{1}=1; %Print in Matlab command window (1 means yes, 0 means No)
args{2}=1; %Printing step
args{3}=2000; %Maximum function evaluations        
% =========================================================================


%==========================================================================    
%                      Performing MVMO-based optimization
%========================================================================== 
minTime = Inf;
tic;
tStart = tic;

fhandle = @test_func2; % Definition of objective/fitness function as a function handle

ps.ofcn_evol=zeros(args{3},1);
ps.fit_evol=zeros(args{3},1);
ps.param_evol=zeros(args{3},ps.D);

op_runs=1;%In case you want to run the whole optimizatin several times (i.e. number of optimization runs)
for iii=1:op_runs
    feval(algorithm_hd,of_apg_hd,iii,args);
end

tElapsed = toc(tStart);
Ctime_min = min(tElapsed, minTime);

plot(ps.fit_evol); 
xlabel('No. of objective function evaluations'); 
ylabel('Fitness value'); 

plot(ps.param_evol(:,1),'red'); %plots x(1)
hold on
plot(ps.param_evol(:,2),'yellow'); %plots x(2)
%========================================================================== 

