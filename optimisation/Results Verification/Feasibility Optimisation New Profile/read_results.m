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
        Ploss_noopt(i-1,1) = Data{1,2}.Results(i).Ploss_mean;   %%no opt
        Ploss_withopt(i-1,1) = Data{1,3}.Results(i).Ploss_mean; %%opt with Q
        Ploss_withopt(i-1,2) = Data{1,4}.Results(i).Ploss_mean; %%opt with Q and taps
        Ploss_withopt(i-1,3) = Data{1,1}.Results(i).Ploss_mean; %%opt with Q and  
    else
         Ploss_noopt(i-1,1) = 0;
         Ploss_withopt(i-1,1) = 0;
         Ploss_withopt(i-1,2) = 0;
         Ploss_withopt(i-1,3) 
    end
end


whichcase = 1:25;
darkblue = '#000066';
blue = '#0000ff';
lightblue = '#00ffff';

fig = figure(1);
left_col = [0 0 0];
right_col = [0/255 128/255 0];
set(fig,'defaultAxesColorOrder',[left_col;left_col]);
hold on
xlabel('Case')
yyaxis left
plot(whichcase,Ploss_noopt,'-o','Color','red')           %%no opt
plot(whichcase,Ploss_withopt(:,1),'-o','Color',blue)   %%opt with Q
ylabel('Loss [MW]')
title('Active power losses: No Optimisation vs Optimisation','FontSize',20);
reduction_losses(:,1) = 1e3.*(Ploss_noopt-Ploss_withopt(:,1));

yyaxis right
plot(whichcase,reduction_losses(:,1),'-o','Color',right_col);
ylabel('Loss Reduction [kW]');
legend('Without Optimisation','With Optimisation','Feasibility of Optimisation');

axes_fontsize = 15;
ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Without Optimisation','With Optimisation','Feasibility of Optimisation');
lgd.FontSize = 15;
lgd.Location = 'northwest';


figure(2)
reduction_losses(:,2) = 1e3*(Ploss_withopt(:,1)-Ploss_withopt(:,2)); % q and taps
reduction_losses(:,3) = 1e3*(Ploss_withopt(:,1)-Ploss_withopt(:,3)); % q and reactor

subplot(121)
hold on
plot(whichcase,Ploss_withopt(:,1),'-o','Color',blue)         %%opt with Q
plot(whichcase,Ploss_withopt(:,2),'--o','Color',darkblue)    %%opt with Q and taps
plot(whichcase,Ploss_withopt(:,3),'-.o','Color',lightblue)    %%opt with Q and R
xlabel('Case')
ylabel('Loss [MW]')
legend('Losses with Q','Losses with Q and taps', 'Losses with Q and reactor'); 

ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Losses with Q','Losses with Q and taps', 'Losses with Q and reactor'); 
lgd.FontSize = 15;
lgd.Location = 'northwest';

subplot(122)
hold on
%plot(cases,reduction_losses(:,1),'Color',blue)
plot(whichcase,reduction_losses(:,2),'--o','Color',darkblue)      %reduction due to taps vs only q
plot(whichcase,reduction_losses(:,3),'-.o','Color',lightblue)     %reduction due to reactor vs only q
xlabel('Case')
ylabel('Reduction in losses [kW]')
legend('Reduction with taps','Reduction with reactor');
ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Reduction with taps','Reduction with reactor'); 
lgd.FontSize = 15;
lgd.Location = 'northwest';
        