clear all
close all

filelist = dir('*.mat');

for i = 1:length(filelist(:,1))
    
    Data{i} = load(filelist(i,1).name,'Results');
end

Results_no_opt(1:6) = Data{1,2}.Results;
Results_no_opt(7:26) = Data{1,1}.Results(7:26);
Results_opt(1:6) = Data{1,4}.Results;
Results_opt(7:26) = Data{1,3}.Results(7:26);


for i = 2:length(Results_opt)
   Results_opt(i).total_cost_per_case = min(Results_opt(i).total_cost_per_run(2:6));
        if Results_no_opt(i).Times_converged >= 5
            costs_no_opt(i-1) =  Results_no_opt(i).total_cost_per_case;
            costs_with_opt(i-1) = Results_opt(i).total_cost_per_case;
            cost_reduction(i-1) = costs_no_opt(i-1)-costs_with_opt(i-1);
        end
end

cases = linspace(1,25,25);

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
plot(cases,costs_no_opt,'-o','Color','red','MarkerSize',3);           
plot(cases,costs_with_opt,'-o','Color',blue,'MarkerSize',3); 
ylabel('Costs [€]');
title('Costs: No Optimisation vs Optimisation','FontSize',20);

yyaxis right
plot(cases,cost_reduction,'-o','Color',right_col,'MarkerSize',3);
ylabel('Cost Reduction [€]');


axes_fontsize = 15;
ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Without optimisation','With optimisation','Feasibility of optimisation');
lgd.FontSize = 15;
lgd.Location = 'northwest';
% 
% %%Calculates the improvement in savings w.r.t only optimising with Q's
% 
% reduction_losses(:,2) = 1e3*(Ploss_withopt(:,1)-Ploss_withopt(:,2)); % q and taps
% reduction_losses(:,3) = 1e3*(Ploss_withopt(:,1)-Ploss_withopt(:,3)); % q and reactor
% reduction_losses(:,4) = 1e3*(Ploss_withopt(:,1)-Ploss_withopt(:,4)); % everything
% 
% figure(2)
% % subplot(121)
% hold on
% plot(whichcase,Ploss_withopt(:,1),'-o','Color',blue,'MarkerSize',3)        %%opt with Q
% plot(whichcase,Ploss_withopt(:,2),'--o','Color',darkblue,'MarkerSize',3)   %%opt with Q and taps
% plot(whichcase,Ploss_withopt(:,3),'-.o','Color',lightblue,'MarkerSize',3)  %%opt with Q and R
% plot(whichcase,Ploss_withopt(:,4),':o','Color',darkblue2,'LineWidth',1.25,'MarkerSize',3)  %%opt with everything
% xlabel('Case')
% ylabel('Loss [MW]')
% title('Active Power Losses with Different Controllable Devices','FontSize',20)
% 
% ax = gca;
% ax.FontSize = axes_fontsize;
% lgd = legend('Losses with Q','Losses with Q and taps', 'Losses with Q and reactor', 'Losses with Q, taps and reactor'); 
% lgd.FontSize = 15;
% lgd.Location = 'northwest';
% 
% figure(3)
% % subplot(121)
% hold on
% plot(whichcase,Ploss_withopt(:,1),'-o','Color',blue,'MarkerSize',3)        %%opt with Q
% plot(whichcase,Ploss_withopt(:,2),'--o','Color',darkblue,'MarkerSize',3)   %%opt with Q and taps
% plot(whichcase,Ploss_withopt(:,3),'-.o','Color',lightblue,'MarkerSize',3)  %%opt with Q and R
% plot(whichcase,Ploss_withopt(:,4),':o','Color',darkblue2,'LineWidth',1.25,'MarkerSize',3)  %%opt with everything
% xlabel('Case')
% ylabel('Loss [MW]')
% xlim([20.5 25.1])
% ylim([4.9 5.8])
% title({'Active Power Losses with Different Controllable Devices:';'zoomed in around case 21-25'},'FontSize',20)
% 
% ax = gca;
% ax.FontSize = axes_fontsize;
% lgd = legend('Losses with Q','Losses with Q and taps', 'Losses with Q and reactor', 'Losses with Q, taps and reactor'); 
% lgd.FontSize = 15;
% lgd.Location = 'northwest';
% 
% figure(4)
% % subplot(122)
% hold on
% %plot(cases,reduction_losses(:,1),'Color',blue)
% plot(whichcase,reduction_losses(:,2),'--o','Color',darkblue,'MarkerSize',3);      %reduction due to taps vs only q
% plot(whichcase,reduction_losses(:,3),'-.o','Color',lightblue,'MarkerSize',3);     %reduction due to reactor vs only q
% plot(whichcase,reduction_losses(:,4),':o','Color',darkblue2,'LineWidth',1.25,'MarkerSize',3);     % reduction due to everything
% xlabel('Case')
% ylabel('Improvement of reduction in losses [kW]')
% title('Improvement of Reduction in Active Power Losses with Different Controllable Devices','FontSize',20)
% ax = gca;
% ax.FontSize = axes_fontsize;
% lgd = legend('Improvement with Q and taps','Improvement with Q and reactor', 'Improvement with Q, taps and reactor'); 
% lgd.FontSize = 15;
% lgd.Location = 'northwest';
        