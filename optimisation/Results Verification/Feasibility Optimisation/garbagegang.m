clear all;

%Plots the losses with and without optimising Q's for different windspeeds

v = 4:1:25;
load('Windspeed powerloss sweep with optimisation.mat');
for i = 1:length(v)
    loss_opt(i) = Results(i+1).Ploss_mean;
end
load('Windspeed powerloss sweep no optimisation.mat');
for i = 1:length(v)
    loss_no_opt(i) = Results(i+1).Ploss_mean;
end

loss_save = (loss_no_opt - loss_opt)*1000; %loss in KW
figure(1);
plot(v,loss_no_opt,'red');
hold on;
plot(v,loss_opt,'green');
xlabel('Windspeed [m/s]');
ylabel('P [MW]');

figure(2);
plot(v,loss_save,'blue');
xlabel('Windspeed [m/s]');
ylabel('P [kW]');
legend('Active power loss savings due to optimisation');