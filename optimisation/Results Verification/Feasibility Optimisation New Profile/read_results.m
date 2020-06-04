clear all
close all

filelist = dir('*.mat');

for i = 1:length(filelist(:,1))
    
    Data{i} = load(filelist(i,1).name,'Results');
end
Ploss_woopt = zeros(1,25);
Ploss_withopt = zeros(1,25);
for i = 1:25
    Ploss_woopt(i) = Data{1,2}.Results(i+1).Ploss_mean;
    Ploss_withopt(i) = Data{1,3}.Results(i+1).Ploss_mean;
end

figure
hold on
cases = 1:25;
xlabel('Case')
yyaxis left
plot(cases,Ploss_woopt,'blue')
plot(cases,Ploss_withopt,'green')
ylabel('Loss [MW]')
title('No Optimisation vs Optimisation','FontSize',20);


yyaxis right
reduction_losses = 1e3*(Ploss_woopt-Ploss_withopt);
money_saved = reduction_losses*8760*0.05;
plot(cases,reduction_losses)
ylabel('Loss reduction [kW]')
legend('Without Optimisation','With Optimisation','Feasibility of Optimisation');
% plot(cases,money_saved)
% ylabel('What can you buy now? [€]')



        