clear
close all

v_initial = [6.5, 7.5, 8.5, 10];
v_final = [v_initial(2:end) v_initial(end)] ;
irradiance_initial = [650, 600, 800, 450];
irradiance_final =[irradiance_initial(2:end), irradiance_initial(end)];
TSO_P_setpoints = [70,70,110,155];
load('String_powers_and_profiles.mat')

% plot(v_profile);

%%Measured P_strings at 0, 15, 30 and 45 minutes
P_current = [P_current_string(1,:); P_current_string(4501,:); P_current_string(9001,:); P_current_string(13501,:)];
P_current = P_current.';

%%Measured P_pcc at 0, 15, 30 and 45 minutes
P_PCC_current = [P_pcc(1), P_pcc(4501), P_pcc(9001), P_pcc(13501)];


[P_strings] = APC_predictor(v_initial, v_final, irradiance_initial, irradiance_final, TSO_P_setpoints, P_current, P_PCC_current);


% P_current_string(1,:)-P_strings(:,1)
% P_current_string(4501,:)-P_strings(:,2)
% P_current_string(9001,:)-P_strings(:,3)
% P_current_string(13501,:)-P_strings(:,4)