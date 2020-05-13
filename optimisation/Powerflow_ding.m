%Authors: Farley Rimon & Marouane Mastouri
%Last updated: 13/05/2020 (dd-mm-yyyy)

%Modeling PF for a Substation with a Wind-and Solar Park
%A case study is loaded with 13 strings of Wind Turbine Generators and 3
%strings from a PV-module.
%Step 2 involves the modeling of the power flow in situations. These are
%useful to determine limiting constraints in the substation's power flow

clear all;
close all;
clc;

%% Step 1: Load data of the case
mpc_substation_system13 = loadcase('system_13');
P_idx = find(mpc_substation_system13.gen(:,2)~=0); %Find indexes of generating strings in generator data
P_wt_idx = P_idx(5:end);
P_pv_idx = P_idx(1:4);
%branch_status_idx = find(mpc_substation_system13.branch(:,11)==0); %Find indexes of generating strings in generator data

%define all constants
%WTG Farm
% type_wtg= 4; %total types of WTG
  v_c_in = 3 ; %general cut in speed in m/s
  v_r = 14 ; %general rated speed in m/s, fixed for step 2a
  v_w = 14 ; %nominal wind speed in m/s
  v_c_off = 25 ; %general cut off speed in m/s
  global P_wt_max;
  P_wt_max = [33.6 29.4 29.4 16.8 32 29.4 16 28 33 29.15 28 28.8 28.8]; %Rated power in MW for each string
  N_strings = 13;
  
%PV farm

  N_daily_dispatch = 96; %total available wind profiles
  N_strings_pv = 4; %total strings
  P_pv_max = [30.3   30.3  30.3  30.3];  %Max active power in MW generated per PV string 1-4 
  A_pv = 181196.1722; %Area in m2 of each PV system , a total of 4 PV
  t_sun_h = 11; % Sun hours per day
  t_increase_h = 6; % 15minutes increase per day needed to go from 0 to max solar irradiance in W/m2
  t_steps = [1:0.25:6];
 
  %Insert seasons
  solar_irr_max= 800; %max solar irradiance in W/m2
  n_pv = 0.22; %efficiency of pv panel
  n_inv =0.95; %efficiency of inverter
  rc_g_solar_irr = (solar_irr_max)/((10-4)); %rc in W/m2 * 15min from 0 solar irradiance to max in, linear increase
  
  P_pv = zeros(N_daily_dispatch, N_strings_pv); %Make matrix for generated nominal solar irradiance\

  solar_irr = rc_g_solar_irr * t_steps;


%% Step 2: Generate random variables

% %Each time, one of the substeps is uncommented and tested.
% %Random variables are created with PDFs
% N_daily_dispatch = 96; %total available wind dispatch profiles
% N_strings = 13 %total Wind Turbine Generators strings
% N_strings_pv = 4 %total PV strings
% 
% %Convert generated power at rated wind speed
% 
% 
% P_wt_max = [33.6 29.4 29.4 16.8 32 29.4 16 28 33 29.15 28 28.8 28.8];  %Rated power in MW for each string 1-13
% Q_wt_max = [21.2 18.55 19.15 10.9 22.4 19.15 12.2 19.6 22.4 13.248 19.6 19.6 19.6] ; %Max positive/negative reactive power in MVAr generated for eacht string 1-13
% P_wt = zeros(N_daily_dispatch, N_strings); %Make matrix for generated nominal wind speed
% 
% P_pv = zeros(N_daily_dispatch, N_strings_pv); %Make matrix for generated nominal solar irradiance
% Q_pv_max = (1/3)*P_pv_max; %Max reactive power in MVAr per PV string 1-4
% 
% 
% for(i=1: length(P_wt_max)) %makes a 1x13
%     for(j=1: N_daily_dispatch) %makes a 96x1
%     %%apply boundary conditions to determine which equation is valid
%      if(v_w(j) <= v_c_in) 
%          P_wt(j,i) =0; 
% 
%     elseif ( (v_w(j) > v_c_in) &&  (v_w(j) <= v_r) ) 
%     
%          P_wt(j,i)=P_wt_max(i)*(v_w(j)^3-v_c_in^3)/(v_r^3-v_c_in^3);
%     
%     elseif ((v_w(j) > v_r) && (v_w(j) <= v_c_off))
%          P_wt(j,i) = P_wt_max(i); %assigns every power to every dispatch 
%     
%      elseif (v_w(j) > v_c_off)
%          P_wt(j,i) = 0;
%      end 
%     end
% end
% 
% %Calculate power generated at each PV String out of dispatch Solar
% %Irradiance (W/m2)
% 
% %Summer model for solar
%    for(i=1: length(P_pv_max)) %makes a 1x4
%        k=1;
%          for(j=1: N_daily_dispatch) %makes a 96x1
%             
%             if (j < (4/24)*N_daily_dispatch ) %Assume before 4 am , no PV energy generated
%                 P_pv(j,i) = 0;
%         
%             elseif( (j >= ((4/24)*N_daily_dispatch)) && (j < ((10/24)*N_daily_dispatch)) )%Assume 4 - 10 am , PV power increasing linearly
%              
%                  P_pv(j,i) = ((solar_irr(k) * A_pv)*n_inv*n_pv)*10^-6; %Output active power in MW
%                  if (k<length(t_steps))
%                     k=k+1;
%                  end 
%             elseif( (j >= ((10/24)*N_daily_dispatch)) && (j < ((21/24)*N_daily_dispatch)) ) %Assume 10 am - 9pm , PV max energy generated
%                    P_pv(j,i) = P_pv_max(1,i);  
%          
%             elseif( (j >= ((21/24)*N_daily_dispatch))  ) %Assume 9 pm -12 am, no PV energy generated
%                  P_pv(j,i) = 0;
%          end
%     end
% end
% 
% 
% 
% %update status of branches for reactor
% % 
% % N_branches_shunt = 2; %Numbers of branches connected to the shunt
% % upd_status = zeros(N_branches_shunt,N_daily_dispatch); %initialize matrix that updates status
% % 
% % for(i=1:N_daily_dispatch)
% %     for(j= N_branches_shunt)
% %         
% %         upd_status(i,j) = randi([0,1]); %assign random 0 or 1 to branches for every dispatch
% %     end
% % end
% 
%% Step 2a: Generate random Qs for fixed nominal wind speed (fixed tapposition, neglect PV farm)

%Random Q_demands of Normal distribution for each string/generator

samples_Q = zeros(N_daily_dispatch,N_strings); %matrix for the random Q_demands
Q_wt_max = [21.2   18.55   19.15   10.9    22.4    19.15   12.2    19.6    22.4    13.248  19.6    19.6    19.6] ; %Max positive/negative reactive power generated for eacht string 1-13

Q_mean = zeros(1, N_strings); %matrix with mu for each string 1-13

samples_Q = zeros(length(Q_mean),1); %initialize matrix for Q random samples

for i=1:length(Q_mean)
    Q_std(i)=unifrnd(1,Q_wt_max(i)); %make a uniform distribution for the standard deviation string 1-13
end


for(i=1:N_strings) %makes a 1x13
  for(j=1: N_daily_dispatch) %makes a 96x1
    samples_Q(j,i)= normrnd(Q_mean(i), 0.75*Q_std(i), [1, 1]); %Creates random samples for Q in 96x13, some values violating the constraints
  end
end

constraints_neg = zeros(N_daily_dispatch,N_strings);
constraints_pos= zeros(N_daily_dispatch,N_strings);
   for(k=1: N_strings)
   constraints_neg = samples_Q(samples_Q < -Q_wt_max(k)); %Note values greater than positive max reactive 
   constraints_pos = samples_Q(samples_Q > Q_wt_max(k));  %Note values greater than negative max reactive
%     
    idx_constraints_neg(:,k) = (samples_Q(:,k) < -Q_wt_max(k)); %Note values greater than max reactive 
    idx_constraints_pos(:,k) = (samples_Q(:,k) >  Q_wt_max(k));
      
   end 
%% Step 2b: Generate random Qs for fixed solar irradiance (and fixed tap
%%position, neglect wind farm)

%1 Assume +-Qmax is 1/3 Pmax

%(2 Assume Pmax, Q=0 & P=0, Qmax, extra task)


% samples_Q_pv = zeros(N_daily_dispatch,N_strings_pv); %matrix for the random Q_demands
% 
% Q_mean_pv = zeros(1, N_strings_pv); %matrix with mu for each string 1-4
% 
% samples_Q_pv = zeros(length(Q_mean_pv),1); %initialize matrix for Q random samples
% 
% for i=1:length(Q_mean_pv)
%     Q_std_pv(i)=unifrnd(1,Q_pv_max(i)); %make a uniform distribution for the standard deviation string 1-4
% end
% 
% 
% for(i=1:N_strings_pv) %makes a 1x4
%   for(j=1: N_daily_dispatch) %makes a 96x1
%     samples_Q_pv(j,i)= normrnd(Q_mean_pv(i), 1*Q_std_pv(i), [1, 1]); %Creates random samples for Q in 96x4, some values violating the constraints
%   end
% end

% constraints_neg_pv = zeros(N_daily_dispatch,N_strings_pv);
% constraints_pos_pv = zeros(N_daily_dispatch,N_strings_pv);
%    for(k=1: N_strings_pv)
% %    constraints_neg_pv = samples_Q_pv(samples_Q_pv < -Q_pv_max(k)); %Note values greater than positive max reactive 
% %    constraints_pos_pv = samples_Q_pv(samples_Q_pv > Q_pv_max(k));  %Note values greater than negative max reactive
% % %     
%     idx_constraints_neg_pv(:,k) = (samples_Q(:,k) < -Q_pv_max(k)); %Note values greater than max reactive 
%     idx_constraints_pos_pv(:,k) = (samples_Q(:,k) >  Q_pv_max(k));
%       
%    end 

%% Step 2c: Generate random Qs and varying wind speeds( no solar irradiance, fixed tap position)

% close all;
% clear all;
% clc;
% 
%   v_c_in = 3 ; %general cut in speed in m/s
%   v_r = 14 ; %general rated speed in m/s, fixed for step 2a
%   v_c_off = 23 ; %general cut off speed in m/s
%   
% N_daily_dispatch = 96;
% N_strings = 13;
% P_wt_max = [33.6 29.4 29.4 16.8 32 29.4 16 28 33 29.15 28 28.8 28.8];  %Rated power in MW for each string 1-13
% Q_wt_max = [21.2 18.55 19.15 10.9 22.4 19.15 12.2 19.6 22.4 13.248 19.6 19.6 19.6] ; %Max positive/negative reactive power in MVAr generated for eacht string 1-13
% 
% %%Generate a random wind distribution
% 
% a= 1.2; %shape parameter in p.u., the lower the more uniformly spread
% b= 12;%scale parameter in m/s, the higher the more the probability is spread
% %rand('twister',5489); % Fix seeds of the random number generator
% rng( 'default'); %specifies seed for the random number generator, seed = 0
% v_w = wblrnd(b,a, [N_daily_dispatch, 1]); %Initialise matrix for random wind speeds
% 
% for(i=1: length(P_wt_max)) %makes a 1x13
%     for(j=1: N_daily_dispatch) %makes a 96x1
%     %%apply boundary conditions to determine which equation is valid
%      if(v_w(j) <= v_c_in) 
%          P_wt(j,i) =0; 
% 
%     elseif ( (v_w(j) > v_c_in) &&  (v_w(j) <= v_r) ) 
%     
%          P_wt(j,i)=P_wt_max(i)*(v_w(j)^3-v_c_in^3)/(v_r^3-v_c_in^3);
%     
%     elseif ((v_w(j) > v_r) && (v_w(j) <= v_c_off))
%          P_wt(j,i) = P_wt_max(i); %assigns every power to every dispatch 
%     
%      elseif (v_w(j) > v_c_off)
%          P_wt(j,i) = 0;
%      end 
%     end
% end
% 
% %%Random Qs for WTG module
% 
% 
% %Q_wt_max = [21.2   18.55   19.15   10.9    22.4    19.15   12.2    19.6    22.4    13.248  19.6    19.6    19.6] ; %Max positive/negative reactive power generated for eacht string 1-13
% rc_string_in = [6.625  6.625   11.969  13.625  6.22    11.969  6.22    6.22    11.2    7.36    6.22    12.25 10.64]; %specifies slope MVAr/MW at beginning for each WTG string
% P_reg_in = [0.1 0.1 0.0544  0.047619    0.1 0.0544  0.1 0.1 0.0606  0.061   0.1 0.0556  0.0556]; %Percentage of total power to reach Q max in capability curve
% rc_string_end = -[1.5    1.5     0.507   3.143   1.48   0.507   1.8519  1.48    0.4408  0.4047   1.48    0.531   0.531]; %specifies slope MVAr/MW at end for each WTG string
% %new_Q_max = [0.72   0.72    0.5117   0.596   0.65    0.5117   0.59    0.643   0.547   0.302   0.643 0.4898   0.4898]' * Q_wt_max; %Calculates new available MVAr at P_wt_max
% P_reg_end = [0.88   0.88    0.372   0.917   0.83125   0.372   0.83125   0.83125   0.3023 0.225  0.83125   0.346   0.346]; %Percentage of total power to reach final Q in capability curve
% 
% samples_Q = zeros(N_daily_dispatch,N_strings); %matrix for the random Q_demands
% Q_wt = zeros (N_daily_dispatch, N_strings);
% 
% 
% for(j=1:N_daily_dispatch)
%     for(i=1:N_strings)
%         %check on boundary values 
% %           k = 1;
%         if (P_wt(j,i) < (P_reg_in(i) .*P_wt_max(i)))
%               Q_wt(j,i) = rc_string_in(i).*P_wt(j,i);
%                 if (Q_wt(j,i) >= Q_wt_max(i))
%                     Q_wt(j,i) = Q_wt_max(i);
%                 end 
%         elseif ((P_wt(j,i) >= (P_reg_in(i).*P_wt_max(i))) && (P_wt(j,i) < (P_reg_end(i).*P_wt_max(i))))
%                
%                Q_wt(j,i) = Q_wt_max(i);
% %                if (k<=N_strings)
% %                k = k + 1;
% %             end
%         elseif ((P_wt(j,i) >= (P_reg_end(i).*P_wt_max(i))) && (P_wt(j,i) <= (P_wt_max(i)))) %%this works
%               Q_wt(j,i) = Q_wt_max(i) + rc_string_end(i).*(P_wt(j,i)-P_reg_end(i).*P_wt_max(i));
%               
%         end 
%     end
% end
% 
% Q_mean = zeros(1, N_strings); %matrix with mu for each string 1-13
% 
% %samples_Q = zeros(length(Q_mean),1); %initialize matrix for Q random samples
% 
% for i=1:length(Q_mean)
%     Q_std(i)=unifrnd(1,Q_wt(i)); %make a uniform distribution for the standard deviation string 1-13
% end
% 
% 
% for(i=1:N_strings) %makes a 1x13
%   for(j=1: N_daily_dispatch) %makes a 96x1
%     samples_Q(j,i)= normrnd(Q_mean(i), 0.75*Q_std(i),[1,1]); %Creates random samples for Q in 96x13, some values violating the constraints
%   end
% end
% 
% 
% constraints_neg = zeros(N_daily_dispatch,N_strings);
% constraints_pos = zeros(N_daily_dispatch,N_strings);
% 
% for(i=1:N_daily_dispatch)   
% for(k=1: N_strings)
%     idx_constraints_neg(:,k) = (samples_Q(:,k) < -Q_wt(:,k)); %Note values greater than max reactive 
%     idx_constraints_pos(:,k) = (samples_Q(:,k) >  Q_wt(:,k));
%     
%     constraints_neg(i,k) = idx_constraints_neg(i,k).*-Q_wt(i,k);
%     constraints_pos(i,k) = idx_constraints_pos(i,k).*-Q_wt(i,k);
% 
%    end
%    end
%  %constraints_neg(:,k) = idx_constraints_neg(:,k).*-Q_wt(:,k);
%  %constraints_pos(:,k)=  idx_constraints_pos(:,k).*Q_wt(:,k);
% 
% %constraints_neg(:,k)= samples_Q(samples_Q < -Q_wt(:,k)); %Note values greater than positive max reactive
% %constraints_pos(:,k) = samples_Q(samples_Q > Q_wt(:,k));  %Note values greater than negative max reactive
% 



%% Step 2d: Generate random wind speeds for fixed Qs (min and max) from 2a
%%that are close to the boundaries (fixed tap
%%position, neglect PV farm)
%% Step 2e: Generate random solar irradiance speeds for fixed Qs (min and
%%max) from 2b that are close to the boundaries (fixed tap
%%position, neglect wind farm)
%% Step 2f: Generate random Qs and random wind speeds & solar irradiance (fixed tap
%%position)
%% Step 2g: 2a&b with randomly generated tap positions for T01 and T02.

%% Step 3: Update case file and run Power Flow

stop =0;
%x=0;
while(stop == 0)
   for(i=1:N_daily_dispatch) 
   for (j=1:N_strings) 
   %for (i=1:N_daily_dispatch)
        %mpc_substation_system13.status(var_branch,11) = upd_branch(k) %%update status of the branch
       
        if(i < N_daily_dispatch)
        mpc_substation_system13.gen(P_wt_idx(j),3) = samples_Q(i,j);
        %results_pf = runpf(mpc_substation_system13); %run power flow once Q is loaded per dispatch
        elseif(i == N_daily_dispatch)
            mpc_substation_system13.gen(P_wt_idx(j),3) = samples_Q(i,j);
            stop = 1;
% if(x == ((N_daily_dispatch * N_strings)-1000))
%     stop = 1; %will stop loading the Qs
 
   end
%%Put some graphs here to show behaviour for busses/branches of interest
    %end
end
   end
end