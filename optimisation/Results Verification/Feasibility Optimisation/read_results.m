clear all
close all

filelist = dir('*.mat');

for i = 1:length(filelist(:,1))
    
    Data{i} = load(filelist(i,1).name,'Results');
end
Ploss_woopt = zeros(1,20);
Ploss_withopt = zeros(1,20);
for i = 1:20
    Ploss_woopt(i) = Data{1,1}.Results(i+1).Ploss_mean;
    Ploss_withopt(i) = Data{1,4}.Results(i+1).Ploss_mean;
end

figure
hold on
cases = 1:20;
xlabel('Case')
yyaxis left
plot(cases,Ploss_woopt)
plot(cases,Ploss_withopt)
ylabel('Loss [MW]')

yyaxis right
reduction_losses = 1e3*(Ploss_woopt-Ploss_withopt);
money_saved = reduction_losses*8760*0.05;
plot(cases,reduction_losses)
ylabel('Reduction in losses [kW]')
% plot(cases,money_saved)
% ylabel('What can you buy now? [€]')



        