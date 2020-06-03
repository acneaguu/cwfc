clear all
close all

%%load powerflow data of system
load('workspace_powerflow.mat','results_inject_t');
load('workspace_powerflow.mat','results_loss_im');

%%calculate the average total branch injection
mean_samples = mean(results_inject_t,2);
tot_inj = sum(mean_samples);

%%generate wind speeds
vmin = 0;
vmax = 25;
stepsize = 0.1;
v = vmin:stepsize:vmax;

%%compute the maximum P/Q production at each V
for i = 1:length(v)
    [P,Q] = compute_pq_wtg(v(i));
    capability(i) = sum(-1*Q);
end

%%plot the park capability with reactor and branch injections
hold on;
plot(v,capability-12,'--b');
legendstr{1} = 'Q_{min} with reactor';
plot(v,capability-12+tot_inj,'b');
legendstr{2} = 'Q_{min} with reactor and branch injections';
plot(v,-capability,'--r');
legendstr{3} = 'Q_{max}';
plot(v,-capability+tot_inj,'r');
legendstr{4} = 'Q_{max} with injections';

%%plot the setpoints
Q = [-100 -50 0 50 100];
threshold = 12.5;
for i = 1:length(Q)
    name = sprintf('%d MVAr',Q(i));
    yline(Q(i),'Color','#04cc82','LineWidth',1.5,'label',name)
    yline(Q(i)+threshold,'--','Color','#013220','LineWidth',1.5)
    yline(Q(i)-threshold,'--','Color','#013220','LineWidth',1.5')
    
    %save the name for the legend
    N = length(legendstr);
    legendstr{N+1} = strcat("Q_{setpoint} = " + '',name);
    legendstr{N+2} = 'Q_{setpoint} + 12.5 MVAr';
    legendstr{N+3} = 'Q_{setpoint} - 12.5 MVAr';
end


%%add labels and legend to the figure
axes_fontsize = 15;
titlesize = 20;

xlabel('Windspeed [m/s]','FontSize',axes_fontsize);
ylabel('Q [MVAr]','FontSize',axes_fontsize);
title('Windfarm reactive power capability','FontSize',titlesize)
ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend(legendstr);
lgd.NumColumns = 3;
lgd.FontSize = 10;
