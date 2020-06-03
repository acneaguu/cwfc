close all
clear all

%%generate the test profile: for each v, 5 Qsetpoints are requested
Qref.setpoint =  [-0.286; -0.143; 0; 0.143; 0.286]; 
v = [4.5 4.5 4.5 4.5 4.5 5 5 5 5 5 7 7 7 7 7 12 12 12 12 12 15 15 15 15 15]';
cases(:,1) = v;
cases(:,2) =repmat(Qref.setpoint,5,1);

%%repeat last entry for legibility
cases(26,1) = 15;
cases(26,2) = 0.286;

%%compute the P/Q for the different cases in p.u.
[P_wtg, Q_wtg] = compute_pq_wtg(cases(:,1));
P = sum(P_wtg,2)/350;
Q = sum(Q_wtg,2)/350;

%%plot variables
axes_fontsize = 15;
titlesize = 20;
Ncase = 1:length(cases(:,1));

%%plot
figure
title('Test profile optimisation unit','FontSize',titlesize)
hold on
%left plot is P
yyaxis left
plot(Ncase,P,'-b');
ylabel('P_{max} [p.u.]','FontSize',axes_fontsize)
%right plot is Qsetpoint
yyaxis right
stairs(Ncase,cases(:,2),'Color','red');
ylabel('Q_{setpoint} [p.u.]','FontSize',axes_fontsize)
xlabel('Case','FontSize',axes_fontsize)

ax = gca;
ax.FontSize = axes_fontsize;