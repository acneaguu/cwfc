close all
clear all

Qref.setpoint =  [-0.286; -0.143; 0; 0.143; 0.286]; 
v = [3.5 4.5 7 15 15 15 7 4.5 3.5 3.5 3.5 4.5 7 4.5 7 15 15 7  4.5 3.5 3.5];
%v = [7 7 7 7 7 15 15 15 15 15]';
%v = [3.5 3.5 3.5 3.5 3.5 4.5 4.5 4.5 4.5 4.5]';
cases(:,1) = v;
cases(:,2) = [-0.286 -0.286 -0.286 -0.286 -0.143 0 0 0 -0.143 0 0.143 0.143 0.143 0.286 0.286 0.286 0.143 -0.143 -0.143 0.286 0.286];
Ncase = 1:length(v);

[P_wtg, Q_wtg] = compute_pq_wtg(v);
P = sum(P_wtg,2)/350;
Q = sum(Q_wtg,2)/350;


figure
title('Test profile optimisation unit')
yyaxis left
hold on
plot(Ncase,P,'-b');
plot(Ncase,Q,'-g');
ylabel('P_{max} [p.u.]')
yyaxis right
stairs(Ncase,cases(:,2),'Color','red');
ylabel('Q_{setpoint} [p.u.]')
xlabel('Case')