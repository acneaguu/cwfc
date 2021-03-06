%Authors: Farley Rimon & Marouane Mastouri
%Last updated: 23/05/2020 (dd-mm-yyyy)

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

%Indicate branch limits for components that cause the constraints
B_limit_1_2 = 400;
B_limit_4_7 = 185.19;
B_limit_4_23 = 185.19;
B_limit_6_12 = 185.19;
B_limit_6_17 = 185.19;


%disconnect PV to run only WTG test

for(i=1:length(P_pv_idx))
    
mpc_substation_system13.gen(P_pv_idx(i),8) = 0; %disconnect PV to run only WTG test

end 

mpc_substation_system13.bus(11,2) = 4;
mpc_substation_system13.bus(16,2) = 4;
mpc_substation_system13.bus(22,2) = 4;
mpc_substation_system13.bus(27,2) = 4;

mpc_substation_system13.branch(10,11) = 0;
mpc_substation_system13.branch(16,11) = 0;
mpc_substation_system13.branch(23,11) = 0;
mpc_substation_system13.branch(29,11) = 0;


%define all constants
%WTG Farm
% type_wtg= 4; %total types of WTG
  v_c_in = 3 ; %general cut in speed in m/s
  v_r = 14 ; %general rated speed in m/s, fixed for step 2a
  %v_w = 14 ; %nominal wind speed in m/s
  v_c_off = 25 ; %general cut off speed in m/s

  P_wt_max = [33.6 29.4 29.4 16.8 32 29.4 16 28 33 29.15 28 28.8 28.8]; %Rated power in MW for each string
  Q_wt_max = [21.2 18.55 19.15 10.9 22.4 19.15 12.2 19.6 22.4 13.248 19.6 19.6 19.6] ; %Max positive/negative reactive power in MVAr generated for eacht string 1-13
 
  N_strings = 13;

  %% Step 2: Generate random variables

%Each time, one of the substeps is uncommented and tested.
%Random variables are created with PDFs
N_daily_dispatch = 10000; %total available wind dispatch profiles
N_strings = 13 %total Wind Turbine Generators strings


% %%Generate a random wind distribution

a= 1.2; %shape parameter in p.u., the lower the more uniformly spread, 1.2 is best
b= 12;%scale parameter in m/s, the higher the more the probability is spread, 12 is best
%rand('twister',5489); % Fix seeds of the random number generator
rng( 'default'); %specifies seed for the random number generator, seed = 0
v_w = wblrnd(b,a, [N_daily_dispatch, 1]); %Initialise matrix for random wind speeds
v = 0:0.1:30;
y = wblcdf(v,b,a);
plot(v,y);
hold on;
%histogram(v_w,N_daily_dispatch);
%Shunt random status, connected or not.

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

%Convert generated power at rated wind speed

P_wt = zeros(N_daily_dispatch, N_strings); %Make matrix for generated nominal wind speed


for(i=1: length(P_wt_max)) %makes a 1x13
    for(j=1: N_daily_dispatch) %makes a 96x1
    %%apply boundary conditions to determine which equation is valid
     if(v_w(j) <= v_c_in) 
         P_wt(j,i) =0; 

    elseif ( (v_w(j) > v_c_in) &&  (v_w(j) <= v_r) ) 
    
         P_wt(j,i)=P_wt_max(i)*(v_w(j)^3-v_c_in^3)/(v_r^3-v_c_in^3);
    
    elseif ((v_w(j) > v_r) && (v_w(j) <= v_c_off))
         P_wt(j,i) = P_wt_max(i); %assigns every power to every dispatch 
    
     elseif (v_w(j) > v_c_off)
         P_wt(j,i) = 0;
     end 
    end
end

%% Step 2c: Generate random Qs and varying wind speeds( no solar irradiance, fixed tap position)


%%Random Qs for WTG module

rc_string_in = [6.625  6.625   11.969  13.625  6.22    11.969  6.22    6.22    11.2    7.36    6.22    12.25 10.64]; %specifies slope MVAr/MW at beginning for each WTG string
P_reg_in = [0.1 0.1 0.0544  0.047619    0.1 0.0544  0.1 0.1 0.0606  0.061   0.1 0.0556  0.0556]; %Percentage of total power to reach Q max in capability curve
rc_string_end = -[1.5    1.5     0.507   3.143   1.48   0.507   1.8519  1.48    0.4408  0.4047   1.48    0.531   0.531]; %specifies slope MVAr/MW at end for each WTG string
%new_Q_max = [0.72   0.72    0.5117   0.596   0.65    0.5117   0.59    0.643   0.547   0.302   0.643 0.4898   0.4898]' * Q_wt_max; %Calculates new available MVAr at P_wt_max
P_reg_end = [0.88   0.88    0.372   0.917   0.83125   0.372   0.83125   0.83125   0.3023 0.225  0.83125   0.346   0.346]; %Percentage of total power to reach final Q in capability curve

samples_Q = zeros(N_daily_dispatch,N_strings); %matrix for the random Q_demands
Q_wt = zeros (N_daily_dispatch, N_strings);


for(j=1:N_daily_dispatch)
    for(i=1:N_strings)
        %check on boundary values 
%           k = 1;
        if (P_wt(j,i) < (P_reg_in(i) .*P_wt_max(i)))
              Q_wt(j,i) = rc_string_in(i).*P_wt(j,i);
                if (Q_wt(j,i) >= Q_wt_max(i))
                    Q_wt(j,i) = Q_wt_max(i);
                end 
        elseif ((P_wt(j,i) >= (P_reg_in(i).*P_wt_max(i))) && (P_wt(j,i) < (P_reg_end(i).*P_wt_max(i))))
               
               Q_wt(j,i) = Q_wt_max(i);
%                if (k<=N_strings)
%                k = k + 1;
%             end
        elseif ((P_wt(j,i) >= (P_reg_end(i).*P_wt_max(i))) && (P_wt(j,i) <= (P_wt_max(i)))) %%this works
              Q_wt(j,i) = Q_wt_max(i) + rc_string_end(i).*(P_wt(j,i)-P_reg_end(i).*P_wt_max(i));
              
        end 
    end
end

Q_mean = zeros(1, N_strings); %matrix with mu for each string 1-13

%samples_Q = zeros(length(Q_mean),1); %initialize matrix for Q random samples

for i=1:length(Q_mean)
    Q_std(i)=unifrnd(1,Q_wt(i)); %make a uniform distribution for the standard deviation string 1-13
end


for(i=1:N_strings) %makes a 1x13
  for(j=1: N_daily_dispatch) %makes a 96x1
    samples_Q(j,i)= normrnd(Q_mean(i), 0.1*Q_std(i),[1,1]); %Creates random samples for Q in 96x13, some values violating the constraints
  end
end

constraints_neg = zeros(N_daily_dispatch,N_strings);
constraints_pos = zeros(N_daily_dispatch,N_strings);

for(i=1:N_daily_dispatch)   
for(k=1: N_strings)
    idx_constraints_neg(:,k) = (samples_Q(:,k) < -Q_wt(:,k)); %Note values greater than max reactive 
    idx_constraints_pos(:,k) = (samples_Q(:,k) >  Q_wt(:,k));
    
    constraints_neg(i,k) = idx_constraints_neg(i,k).*-Q_wt(i,k);
    constraints_pos(i,k) = idx_constraints_pos(i,k).*-Q_wt(i,k);

   end
   end
 %constraints_neg(:,k) = idx_constraints_neg(:,k).*-Q_wt(:,k);
 %constraints_pos(:,k)=  idx_constraints_pos(:,k).*Q_wt(:,k);

%constraints_neg(:,k)= samples_Q(samples_Q < -Q_wt(:,k)); %Note values greater than positive max reactive
%constraints_pos(:,k) = samples_Q(samples_Q > Q_wt(:,k));  %Note values greater than negative max reactive

%% Step 3: Update case file and run Power Flow

stop =0;
%x=0;
k=1;
while(stop == 0)
   for(i=1:N_daily_dispatch) 
   for (j=1:N_strings)
   %for (k=1:N_branches_shunt)
       
          if(i < N_daily_dispatch)
        mpc_substation_system13.gen(P_wt_idx(j),3) = samples_Q(i,j);
        %mpc_substation_system13.bus(28,2) =   upd_status_bus(k,i) ; %Find 
        %mpc_substation_system13.branch(branch_r_status_idx(k),11) = upd_status(k,i); %Find indexes of generating strings in generator data
        
        %run power flow for each dispatch
        if((v_w(i) > 3) && (v_w(i) <= 25))
        results_pf = runpf(mpc_substation_system13); %run power flow once Q is loaded per dispatch
        [results_loss results_inject] = get_losses(results_pf); %losses
        k= k+1; %counter for converging power flows
        %Make matrix to specify branch losses and reactive power injection
        results_loss_matrix = zeros(31, 50); %first row is bus "from", second row bus "to", third row is loss

        bus_from = mpc_substation_system13.branch(:,1);
        bus_to = mpc_substation_system13.branch(:,2);
    
        %Perform operation only if system converges
          if (results_pf.success == 1)
              
        %Save data for each power flow  
        Vmag(:,i) = results_pf.bus(:,8); %Saves voltage magnitude for every bus
        Vangle(:,i) = results_pf.bus(:,9); %Saves angle magnitude for every bus
        P_flow_1_2(:,i) = results_pf.branch(1,16); %Saves Power flow in MW for Branch to PCC
        P_flow_4_23(:,i) = results_pf.branch(25,16); %Saves Power flow in MW for Branch to Input transformer 1
        P_flow_4_7(:,i) = results_pf.branch(6,16); %Saves Power flow in MW for Branch to Input transformer 1
        P_flow_6_12(:,i) = results_pf.branch(12,16); %Saves Power flow in MW for Branch to Input transformer 2
        P_flow_6_17(:,i) = results_pf.branch(18,16); %Saves Power flow in MW for Branch to Input transformer 2
        
        results_loss_real(:,i) = real(results_loss);
        results_loss_im(:,i) = imag(results_loss);
        results_inject_t(:,i) = results_inject;
        results_loss_matrix = [bus_from bus_to results_loss_real results_loss_im    results_inject_t];
        
          end 

          elseif(i == N_daily_dispatch)
            mpc_substation_system13.gen(P_wt_idx(j),3) = samples_Q(i,j);
            
         if (results_pf.success == 1)
             
        %Save data for each power flow 
        Vmag(:,i) = results_pf.bus(:,8);
        Vangle(:,i) = results_pf.bus(:,9);
        P_flow_1_2(:,i) = results_pf.branch(1,16); %Saves Power flow in MW for Branch to PCC
        P_flow_4_23(:,i) = results_pf.branch(25,16); %Saves Power flow in MW for Branch to Input transformer 1
        P_flow_4_7(:,i) = results_pf.branch(6,16); %Saves Power flow in MW for Branch to Input transformer 1
        P_flow_6_12(:,i) = results_pf.branch(12,16); %Saves Power flow in MW for Branch to Input transformer 2
        P_flow_6_17(:,i) = results_pf.branch(18,16); %Saves Power flow in MW for Branch to Input transformer 2
        
        %Save all the losses generated in each bus/branch for all
        %dispatches
        results_loss_real(:,i) = real(results_loss);
        results_loss_im(:,i) = imag(results_loss);
        results_inject_t(:,i) = results_inject;
        results_loss_matrix = [bus_from bus_to results_loss_real results_loss_im    results_inject_t];
        
        %Computes location and value of maximum loss
        %[p_max_loss p_max_loss_idx] = max(results_loss_real,[],2);
        %[q_max_loss q_max_loss_idx]=  max(results_loss_im,[],2);
        constraints_v_low = Vmag(Vmag < 0.99); %Note values greater than minimum p.u.
        constraints_v_high = Vmag(Vmag > 1.05);  %Note values greater than maximum p.u.
     
        idx_constraints_v_low = zeros(28, k); %28 is amount of busses in the circuit
for (a=1:k)
        %Vlow is ..... for shunt connected
        %Vlow is ..... for shunt disconnected
        %Vhigh is ..... for shunt connected
        %Vhigh is ..... for shunt disconnected
    
        idx_constraints_v_low(:,a) = (Vmag(:,a) < 0.99); 
        idx_constraints_v_high(:,a) = (Vmag(:,a) > 1.05);
        [idx_r_Q_v_low idx_c_Q_v_low] = find(idx_constraints_v_low~=0); %find location in matrix where there is v low
        [idx_r_Q_v_high idx_c_Q_v_high] = find(idx_constraints_v_high~=0);
end
        
        Q_dem_constraints_v_low = samples_Q(idx_c_Q_v_low,:); %Find the Q demands for that specific dispatch
        Q_dem_constraints_v_high = samples_Q(idx_c_Q_v_high,:); %Find the Q demands for that specific dispatch
        
        P_loss_v_low = results_loss_real(:, idx_c_Q_v_low);
        P_loss_v_high = results_loss_real(:, idx_c_Q_v_high);
        
        Q_loss_v_low = results_loss_im(:, idx_c_Q_v_low);
        Q_loss_v_high = results_loss_im(:, idx_c_Q_v_high);
        
        Q_inj_v_low = results_inject_t(:, idx_c_Q_v_low);
        Q_inj_v_high = results_inject_t(:, idx_c_Q_v_high);
        
         end
 end             
 end        
      stop = 1; %stop while loop
   end
 
        end
 end
%end 

        %% Step 4: Plot results in a visable manner
        
        %Print  voltage data
        figure(1)
        subplot(2,1,1)
        plot(Vmag,'o');
        xlabel('Bus number');
        ylabel('V magnitude (p.u.)');
        title('Voltage magnitude in p.u. for bus numbers')
        hold on;
        
        subplot(2,1,2)
        plot(Vangle,'s');
        xlabel('Bus number');
        ylabel('V angle (degrees)');
        title('Voltage angles in degrees for bus numbers')
        hold on;
        
        %Print losses data
        figure(2)
        subplot(3,1,1)
        plot(results_loss_real,'o');
        xlabel('Branch #');
        ylabel('P loss(MW)');
        title('Active power loss in MW for branch')
        hold on;

        
        subplot(3,1,2)
        plot(results_loss_im,'s');
        xlabel('Branch #');
        ylabel('Q loss(MVAr)');
        title('Reactive power loss in MVAr for branch')
        hold on;
        
        subplot(3,1,3)
        plot(results_inject_t,'o');
        xlabel('Branch #');
        ylabel('Q injected(MVAr)');
        title('Reactive power inject in MVAr for branch')
        hold on;
        
        figure(6)

        plot(P_flow_1_2,'o');
        xlabel('Dispatch');
        ylabel('Power flow (MW)');
%         x = [1 N_daily_dispatch];
%         y = [B_limit_1_2];
%         pl = line(x,y);
%         plot(x,y);
        yline(B_limit_1_2 ,'r');
        title('Power flow through PCC Branch 1-2');
        hold on;
        
        figure(7)
        subplot(2,1,1)
     
        plot(P_flow_4_7,'o');
        xlabel('Dispatch');
        ylabel('Power flow (MW)');
        yline(B_limit_4_7 ,'r');
        title('Power flow to input Transformer 1 Branch 4-7');
        hold on;
        
        subplot(2,1,2)
     
        plot(P_flow_4_23,'o');
        xlabel('Dispatch');
        ylabel('Power flow (MW)');
        yline(B_limit_4_23 ,'r');
        title('Power flow to input Transformer 1 Branch 4-23')
        hold on;
        
        figure(8)
        subplot(2,1,1)
     
        plot(P_flow_6_12,'o');
        xlabel('Dispatch');
        ylabel('Power flow (MW)');
        yline(B_limit_6_12 ,'r');
        title('Power flow to input Transformer 2 Branch 6-12')
        hold on;
        
        subplot(2,1,2)
     
        plot(P_flow_6_17,'o');
        xlabel('Dispatch');
        ylabel('Power flow (MW)');
        yline(B_limit_6_17 ,'r');
        title('Power flow to input Transformer 2 Branch 6-17')
        hold on;
        
        
        %Print relation between demand, total system losses and voltage
        
        %Calculate average voltage for specific Q_demand
        v_avg = mean(Vmag);
        
        %Calculate average minimum voltage for specific Q_demand
        %this is equal to constraints_v_low
        
        %Calculate total losses for average voltage of each dispatch
        P_loss_tot = sum(results_loss_real);
        Q_loss_tot = sum(results_loss_im);
        Q_inj_tot = sum(results_inject_t);
        
        %Calculate total losses for voltage constraints
        P_loss_tot_v_low = sum(P_loss_v_low);
        Q_loss_tot_v_low = sum(Q_loss_v_low);
        Q_inj_tot_v_low = sum(Q_inj_v_low);
        
        P_loss_tot_v_high = sum(P_loss_v_high);
        Q_loss_tot_v_high = sum(Q_loss_v_high);
        Q_inj_tot_v_high = sum(Q_inj_v_high);
        
        %Calculate total Q_demand
    
        Q_tot = sum(samples_Q,2);
        
        %Calculate total Q_demand for dispatches causing violation

        Q_tot_constraints_v_low = sum(Q_dem_constraints_v_low,2);
        Q_tot_constraints_v_high = sum(Q_dem_constraints_v_high,2);
         
        %Plot 3D plot Q demand, P loss and (minimum and maximum) average voltage
        figure(3)
       
        plot3(Q_tot, P_loss_tot, v_avg,'o','Color', 'r', 'MarkerSize',5); %plot for avg
        hold on;
        plot3(Q_tot_constraints_v_low, P_loss_tot_v_low,constraints_v_low,'o','Color', 'b', 'MarkerSize',5); %plot for v constraints low
        hold on;
        plot3(Q_tot_constraints_v_high, P_loss_tot_v_high, constraints_v_high,'o','Color', 'k', 'MarkerSize',5); %plot for v constraints low
        hold on;
        
        grid on;
        
        xlabel('Q demand (MVAr)');
        ylabel('P loss total (MW)');
        zlabel('V average magnitude (p.u.)');
        
        %Plot 3D plot Q loss for minimum and average voltage
        figure(4)
      
        plot3(Q_tot, Q_loss_tot, v_avg,'o','Color', 'r', 'MarkerSize',5); %plot for avg
        hold on;
        plot3(Q_tot_constraints_v_low, Q_loss_tot_v_low, constraints_v_low,'o','Color', 'b', 'MarkerSize',5); %plot for v constraints low
        hold on;
        plot3(Q_tot_constraints_v_high, Q_loss_tot_v_high', constraints_v_high,'o','Color', 'k', 'MarkerSize',5); %plot for v constraints low
        hold on;
        
        grid on;
        
        xlabel('Q demand (MVAr)');
        ylabel('Q loss total (MVAr)');
        zlabel('V average magnitude (p.u.)');
       
        %Plot 3D plot for minimum and average
        figure(5)
        
        plot3(Q_tot, Q_inj_tot,v_avg,'o','Color', 'r', 'MarkerSize',5); %plot for avg
        hold on;
        plot3(Q_tot_constraints_v_low,Q_inj_tot_v_low, constraints_v_low,'o','Color', 'b', 'MarkerSize',5); %plot for v constraints low
        hold on;
        plot3(Q_tot_constraints_v_high, Q_inj_tot_v_high', constraints_v_high,'o','Color', 'k', 'MarkerSize',5); %plot for v constraints low
        hold on;
        
        grid on;
        
        xlabel('Q demand (MVAr)');
        ylabel('Q INJ total (MVAr)');
        zlabel('V average magnitude (p.u.)');



