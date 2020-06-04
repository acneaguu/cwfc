clear all
close all

filelist = dir('*.mat');

for i = 1:length(filelist(:,1))
    
    Data{i} = load(filelist(i,1).name,'Results');
end

Ndatapoints = 0;
for i = 2:length(Data{1,2}.Results)
    if Data{1,2}.Results(i).Times_converged >= 5
        Ndatapoints = Ndatapoints +1;
    end
end

Ploss_noopt = zeros(Ndatapoints,1);
Ploss_withopt = zeros(Ndatapoints,3);
N = 1;
for i = 2:length(Data{1,2}.Results)
    if Data{1,2}.Results(i).Times_converged >= 5
        Ploss_noopt(N,1) = Data{1,2}.Results(i).Ploss_mean;   %%no opt
        Ploss_withopt(N,1) = Data{1,3}.Results(i).Ploss_mean; %%opt with Q
        Ploss_withopt(N,2) = Data{1,4}.Results(i).Ploss_mean; %%opt with Q and taps
        Ploss_withopt(N,3) = Data{1,1}.Results(i).Ploss_mean; %%opt with Q and R
        N=N+1;
    end
end


cases = 1:Ndatapoints;
darkblue = '#000066';
blue = '#0000ff';
lightblue = '#00ffff';

fig = figure(1);
left_col = [0 0 0];
right_col = [124/255 252/255 0];
set(fig,'defaultAxesColorOrder',[left_col;right_col]);
hold on
xlabel('Case')
yyaxis left
plot(cases,Ploss_noopt,'red')           %%no opt
plot(cases,Ploss_withopt(:,1),'-','Color',blue)   %%opt with Q
ylabel('Loss [MW]')
title('No Optimisation vs Optimisation','FontSize',20);
reduction_losses(:,1) = 1e3.*(Ploss_noopt-Ploss_withopt(:,1));

yyaxis right
plot(cases,reduction_losses(:,1),'#7CFC00');
ylabel('Reduction in losses [kW]');
legend('Without Optimisation','With Optimisation','Feasibility of Optimisation');

figure(2)
reduction_losses(:,2) = 1e3*(Ploss_withopt(:,1)-Ploss_withopt(:,2)); % q and taps
reduction_losses(:,3) = 1e3*(Ploss_withopt(:,1)-Ploss_withopt(:,3)); % q and reactor

subplot(121)
hold on
plot(cases,Ploss_withopt(:,1),'-','Color',blue)         %%opt with Q
plot(cases,Ploss_withopt(:,2),'--','Color',darkblue)    %%opt with Q and taps
plot(cases,Ploss_withopt(:,3),'-.','Color',lightblue)    %%opt with Q and R
xlabel('Case')
ylabel('Active Power Loesoe [MW]')
legend('Losses with Q','Losses with Q and taps', 'Losses with Q and reactor'); 

subplot(122)
hold on
%plot(cases,reduction_losses(:,1),'Color',blue)
plot(cases,reduction_losses(:,2),'--','Color',darkblue)      %reduction due to taps vs only q
plot(cases,reduction_losses(:,3),'-.','Color',lightblue)     %reduction due to reactor vs only q
xlabel('Case')
ylabel('Reduction in losses [kW]')
legend('Reduction with taps','Reduction with reactor');
        