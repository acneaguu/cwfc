
clear all
close all
load('workspace_powerflow.mat','results_inject_t');
load('workspace_powerflow.mat','results_loss_im');

mean_samples = mean(results_inject_t,2);

tot_inj = sum(mean_samples);

stepsize = 0.1;
vmin = 0;
vmax = 25;
v = vmin:stepsize:vmax;
for i = 1:length(v)
    [P,Q] = compute_pq_wtg(v(i));
    capability(i) = sum(-1*Q);
end
plot(v,capability-12+tot_inj);
hold on;
plot(v,-capability+tot_inj);
yline(0);
yline(-50);
yline(-100);
yline(-75,'--g');
yline(-125,'--g');

yline(50);


yline(100);
yline(75,'--g');
yline(125,'--g');
xlabel('Windspeed [m/s]');
ylabel('Q [MVAr]');
