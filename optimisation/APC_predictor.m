function [P_strings] = APC_predictor(v_initial, v_final, irradiance_initial, irradiance_final, TSO_P_setpoints, P_current, P_PCC_current)
% Predict the distribution of active power over the strings.
for m = 1:length(v_initial)
dt = 200e-3;                                    % 10 ms sample time
Tfinal = 900;                                   % simulation will last 18000 s
Ntb = 13;                                       % number of wind turbine strings
Npv = 4;                                        % number of PV module strings
t = 0:dt:Tfinal;                                % time vector
P_sp_pcc = zeros(length(t), 1);                 % initialize input vector with P set points
P_a_string = zeros(length(t), Ntb+Npv);         % initialize matrix with available P per string over time
P_sp_string = zeros(length(t),Ntb+Npv);         % initialize active power set point per string over time
P_current_string  = zeros(length(t), Ntb+Npv);  % initialize current active power produced per string over time
a_p = 70;                                       % initialize a_p constant for the distribution factors 
P_pcc = zeros(1,length(t));                     % initialize vector with current PCC value
case_log = zeros(1,length(t));                  % initialize case log
P_a_tot = zeros(1,length(t));                   % total available power
P_a_wind = zeros(1,length(t));                  % total available wind power
Run_pf_setting = mpoption('verbose',0,'out.all',0); % hide MATPOWER output

%% setting up input vector P_sp_PCC containing the setpoints %%
m
TSO_P_setpoints(m)
length(t)
P_sp_pcc = linspace(TSO_P_setpoints(m),TSO_P_setpoints(m),length(t));

%% Initialize wind profile %%

v_profile = linspace(v_initial(m),v_final(m),length(t));

[P_a_string(:,1:Ntb),Qwtg_string_profile] = compute_pq_wtg(v_profile);

%% Initialize irradiance profile  %%

solar_profile = linspace(irradiance_initial(m), irradiance_final(m), length(t));
[P_a_pv,Qpvg_string_profile] = compute_pq_pvg(solar_profile,Npv);
P_a_string(:,Ntb+1:end) = P_a_pv.';

%% Run simulation %%

% run initial powerflow % 
system = loadcase('system_17');

P_current_string(1,:) = P_current(:,m);

P_pcc(1) = P_PCC_current(m);

% initialize cases %     
case_1=0;
case_2=0;
case_3=0;
case_3b=0;   

% beta opslaan!!!

% Iterate over time %

for j = 1:length(t)-1
     
    P_a_tot(j) = sum(P_a_string(j,:));
    P_a_wind(j) = sum(P_a_string(j,1:13));
    
    Delta_pcc = P_sp_pcc(j)-P_pcc(j);

    % check for which case applies %
    if j>1
        if P_sp_pcc(j) < P_a_tot(j) && P_sp_pcc(j)<P_sp_pcc(j-1)
            if P_sp_pcc(j) < P_a_tot(j) && P_sp_pcc(j)<P_sp_pcc(j-1) && case_2 == 1
                case_1 = 0;
                case_2 = 0;
                case_3 = 1;
                case_log(j) = 3;
                case_3b = 1;
            else
                case_1 = 0;
                case_2 = 0;
                case_3 = 1;
                case_log(j) = 3;
                case_3b = 0;
            end
        elseif P_sp_pcc(j) < P_a_tot(j)
            case_1 = 1;
            case_2 = 0;
            case_3 = 0;
            case_3b  =0;
            case_log(j) = 1;
        else
            case_1 = 0;
            case_2 = 1;
            case_3 = 0;
            case_3b = 0;
            case_log(j) = 2;
        end
    else
        if P_sp_pcc(j) < P_a_tot(j)
                case_1 = 1;
        else
                case_2 = 1;
        end
    end
    
    % determine set points %
    
    if case_1 == 1
        
        beta = calc_DF(P_current_string(j,:),P_a_string(j,:),a_p);
        %beta = ones(1,Ntb+Npv)* (1/(Ntb+Npv));
        P_sp_string(j,:) = P_current_string(j,:) + beta*Delta_pcc;
        
    elseif case_2 == 1
        
        beta = (P_a_string(j,:) - P_current_string(j,:))/Delta_pcc;
        %beta = ones(1,Ntb+Npv)* (1/(Ntb+Npv));       
        P_sp_string(j,:) = P_current_string(j,:) + beta*Delta_pcc;
        
    else
        
        % find out which strings are producing at their max
        Ps_op_max = zeros(1,Ntb+Npv);  % initialize vector with info on which strings are producing at their max
        Ns_max = 0;                    % initialize number of strings producing at their max
        for i = 1:Ntb+Npv
            if P_current_string(j,i) >= P_a_string(j,i)
                Ns_max = Ns_max + 1;
                Ps_op_max(i) = 1;
            end
        end
        
        if case_3b == 1
            Psub = ( sum(P_current_string(j,:))- P_sp_pcc(j) ) / Ns_max;
        else
            Psub = ( P_sp_pcc(j-1)-P_sp_pcc(j) ) / Ns_max;  % amount of active power that will be deducted
                                                            % from turbines producing at their max
        end
        
        % reduce the output of the wind turbines producing at maximum % 
        for i = 1:Ntb+Npv
            if Ps_op_max(i)== 1
                P_sp_string(j,i) = P_current_string(j,i) - Psub;
            else
                P_sp_string(j,i) = P_current_string(j,i);
            end
        end
        if Ns_max == 0
            beta = calc_DF(P_current_string(j,:),P_a_string(j,:),a_p);
            %beta = ones(1,Ntb+Npv)* (1/(Ntb+Npv));
            P_sp_string(j,:) = P_current_string(j,:) + beta*Delta_pcc;
        end
        
    end
    
    % in case a set point becomes negative, the set point is set to zero %
    % and the amount the needs to be deducted is equally divided among other turbines %
       
     n=0;
     redivide = 0;
     for l = 1:Ntb+Npv
         if P_sp_string(j,l) < 0
            n = n+1;
            redivide = redivide + abs(P_sp_string(j,l));
            P_sp_string(j,l) = 0;
         end   
     end
     Psubsub = redivide/(Ntb+Npv-n);
     d=0;
     k=0;
     for l = 1:Ntb+Npv
         if P_sp_string(j,l) > Psubsub
             k = k + 1;
             P_sp_string(j,l) = P_sp_string(j,l)-Psubsub;
         else
             d = d+1;
             Psubsub = Psubsub + ((Psubsub-P_sp_string(j,l)) / (Ntb+Npv-n-k-d));
             P_sp_string(j,l) = 0;
         end
     end
    
    % apply set points %
    system.gen(6:end,[2,9,10]) = [P_sp_string(j,1:Ntb).' P_sp_string(j,1:Ntb).' P_sp_string(j,1:Ntb).'];
    system.gen(2:5,[2,9,10]) = [P_sp_string(j,Ntb+1:end).' P_sp_string(j,Ntb+1:end).' P_sp_string(j,Ntb+1:end).'];
    current_values = runpf(system, Run_pf_setting);
    P_current_string(j+1,1:Ntb) = current_values.gen(6:18,2);     
    P_current_string(j+1,Ntb+1:end) = current_values.gen(2:5,2);
    P_pcc(j+1) = -1 * current_values.branch(1,14);    
end

% % Plot set point response % 
% plot(t,P_pcc)
% hold on
% plot(t,P_sp_pcc)
% plot(t,P_a_tot, t, P_a_wind)
% xlim([t(1) t(end)])
% title('Active power response for high wind profile', 'FontSize', 24)
% xlabel('Time [s]', 'FontSize', 24)
% ylabel('Power [MW]', 'FontSize', 24)
% legend('PPM Response','TSO Set point', 'Total Available power', 'Wind Power')
% legend.FontSize = 24;
% 
% % Plot wind profies % 
% figure(2)
% plot(t,v_profile)
% xlim([t(1) t(end)])
% title('Wind profile', 'FontSize', 24)
% xlabel('Time [s]', 'FontSize', 24)
% ylabel('Wind speed [m/s]', 'FontSize', 24)
% 
% % Plot irradiance profile %
% figure(3)
% plot(t,solar_profile)
% xlim([t(1) t(end)])
% title('Irradiance profile', 'FontSize', 24)
% xlabel('Time [s]', 'FontSize', 24)
% ylabel('Irradiance [W/m^{2}]', 'FontSize', 24)
% figure(4)
% 
% % Plot case occurences %
% plot(t,case_log*100)
% xlim([t(1) t(end)])
% title('Cases that occur during simulation', 'FontSize', 24)
% xlabel('Time [s]', 'FontSize', 24)
% ylabel('Case nuber times 100', 'FontSize', 24)
% 
% % Plot individual set points % 
% figure(5)
% plot(t,P_sp_string(:,1), t,P_sp_string(:,2),t,P_sp_string(:,3),t,P_sp_string(:,4))
% hold on
% plot(t,P_sp_string(:,5),t,P_sp_string(:,6),t,P_sp_string(:,7),t,P_sp_string(:,8))
% plot(t,P_sp_string(:,9),t,P_sp_string(:,10),t,P_sp_string(:,11))
% plot(t,P_sp_string(:,12),t,P_sp_string(:,13),t,P_sp_string(:,14))
% plot(t,P_sp_string(:,15),t,P_sp_string(:,16),t,P_sp_string(:,17))
% xlim([t(1) t(end)])
% title('Individual set points for strings', 'FontSize', 24)
% xlabel('Time [s]', 'FontSize', 24)
% ylabel('Power [MW]', 'FontSize', 24)

P_strings(m,:) = P_current_string(end,:) 
end
end
%% Distribution factor %%
function [ beta ] = calc_DF( P, P_a, a_p)
s = (P_a.^2) ./ (P_a.^2 + a_p);
for k =1:length(s)
    if P(k) >= P_a(k)
        s(k) = 0;
    end
end
if sum(s) == 0
    beta = 0;
else
    beta = (s./sum(s));
end
end