clear all
close all

filelist = dir('*.mat');

for i = 1:length(filelist(:,1))
    
    Data{i} = load(filelist(i,1).name,'Results');
end
Ndatapoints = 25;
Ploss_noopt = zeros(Ndatapoints,1);
Ploss_withopt = zeros(Ndatapoints,4);
for i = 2:length(Data{1,2}.Results)
    if Data{1,2}.Results(i).Times_converged >= 5
        Ploss_noopt(i-1,1) = Data{1,2}.Results(i).Ploss_mean;   %%no opt
        Ploss_withopt(i-1,1) = Data{1,3}.Results(i).Ploss_mean; %%opt with Q
        Ploss_withopt(i-1,2) = Data{1,4}.Results(i).Ploss_mean; %%opt with Q and taps
        Ploss_withopt(i-1,3) = Data{1,1}.Results(i).Ploss_mean; %%opt with Q and  
        Ploss_withopt(i-1,4) = Data{1,5}.Results(i).Ploss_mean; %% opt with everything
    else
         Ploss_noopt(i-1,1) = 0;
         Ploss_withopt(i-1,1) = 0;
         Ploss_withopt(i-1,2) = 0;
         Ploss_withopt(i-1,3) = 0;
         Ploss_withopt(i-1,4) = 0;
    end
end


whichcase = 1:25;
darkblue = '#000066';
blue = '#0000ff';
lightblue = '#00ffff';
darkblue2 =  '#000033';

fig = figure(1);
left_col = [0 0 0];
right_col = [0/255 128/255 0];
set(fig,'defaultAxesColorOrder',[left_col;left_col]);
hold on
xlabel('Case')
yyaxis left
plot(whichcase,Ploss_noopt,'-o','Color','red','MarkerSize',3)           %%no opt
plot(whichcase,Ploss_withopt(:,1),'-o','Color',blue,'MarkerSize',3)   %%opt with Q
ylabel('Loss [MW]')
title('Active Power Losses: No Optimisation vs Optimisation','FontSize',20);
reduction_losses(:,1) = 1e3.*(Ploss_noopt-Ploss_withopt(:,1));

yyaxis right
plot(whichcase,reduction_losses(:,1),'-o','Color',right_col,'MarkerSize',3);
ylabel('Loss reduction [kW]');
legend('Without optimisation','With optimisation','Feasibility of optimisation');

axes_fontsize = 15;
ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Without optimisation','With optimisation','Feasibility of optimisation');
lgd.FontSize = 15;
lgd.Location = 'northwest';

reduction_losses(:,2) = 1e3*(Ploss_withopt(:,1)-Ploss_withopt(:,2)); % q and taps
reduction_losses(:,3) = 1e3*(Ploss_withopt(:,1)-Ploss_withopt(:,3)); % q and reactor
reduction_losses(:,4) = 1e3*(Ploss_withopt(:,1)-Ploss_withopt(:,4)); % everything

figure(2)
% subplot(121)
hold on
plot(whichcase,Ploss_withopt(:,1),'-o','Color',blue,'MarkerSize',3)        %%opt with Q
plot(whichcase,Ploss_withopt(:,2),'--o','Color',darkblue,'MarkerSize',3)   %%opt with Q and taps
plot(whichcase,Ploss_withopt(:,3),'-.o','Color',lightblue,'MarkerSize',3)  %%opt with Q and R
plot(whichcase,Ploss_withopt(:,4),':o','Color',darkblue2,'LineWidth',1.25,'MarkerSize',3)  %%opt with everything
xlabel('Case')
ylabel('Loss [MW]')
title('Active Power Losses with Different Controllable Devices','FontSize',20)

ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Losses with Q','Losses with Q and taps', 'Losses with Q and reactor', 'Losses with Q, taps and reactor'); 
lgd.FontSize = 15;
lgd.Location = 'northwest';

figure(3)
% subplot(121)
hold on
plot(whichcase,Ploss_withopt(:,1),'-o','Color',blue,'MarkerSize',3)        %%opt with Q
plot(whichcase,Ploss_withopt(:,2),'--o','Color',darkblue,'MarkerSize',3)   %%opt with Q and taps
plot(whichcase,Ploss_withopt(:,3),'-.o','Color',lightblue,'MarkerSize',3)  %%opt with Q and R
plot(whichcase,Ploss_withopt(:,4),':o','Color',darkblue2,'LineWidth',1.25,'MarkerSize',3)  %%opt with everything
xlabel('Case')
ylabel('Loss [MW]')
xlim([20.5 25.1])
ylim([4.9 5.8])
title({'Active Power Losses with Different Controllable Devices:';'zoomed in around case 21-25'},'FontSize',20)

ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Losses with Q','Losses with Q and taps', 'Losses with Q and reactor', 'Losses with Q, taps and reactor'); 
lgd.FontSize = 15;
lgd.Location = 'northwest';

figure(4)
% subplot(122)
hold on
%plot(cases,reduction_losses(:,1),'Color',blue)
plot(whichcase,reduction_losses(:,2),'--o','Color',darkblue,'MarkerSize',3);      %reduction due to taps vs only q
plot(whichcase,reduction_losses(:,3),'-.o','Color',lightblue,'MarkerSize',3);     %reduction due to reactor vs only q
plot(whichcase,reduction_losses(:,4),':o','Color',darkblue2,'LineWidth',1.25,'MarkerSize',3);     % reduction due to everything
xlabel('Case')
ylabel('Improvement of reduction in losses [kW]')
title('Improvement of Reduction in Active Power Losses with Different Controllable Devices','FontSize',20)
ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Improvement with Q and taps','Improvement with Q and reactor', 'Improvement with Q, taps and reactor'); 
lgd.FontSize = 15;
lgd.Location = 'northwest';
        