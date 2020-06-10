clear all
close all

%%read data 
filelist = dir('*.mat');

for i = 1:length(filelist(:,1))
    Data{i} = load(filelist(i,1).name,'Results');
end

%%retrieve total costs and Ploss from data
costs_withopt = NaN * ones(1,25);
Ploss_withopt = NaN * ones(1,25);
costs_woopt = NaN * ones(1,25);
Ploss_woopt = NaN * ones(1,25);
costs_diffpar = NaN * ones(1,25);
Ploss_diffpar = NaN * ones(1,25);
costs_onlyP = NaN * ones(1,25);
Ploss_onlyP = NaN * ones(1,25);

for i = 2:26
    if i ~= 2&&i ~= 3&&i ~= 7
        costs_withopt(i-1) = Data{1,1}.Results(i).total_cost_per_case;
        Ploss_withopt(i-1) = Data{1,1}.Results(i).Ploss_best;
        costs_woopt(i-1) = Data{1,2}.Results(i).total_cost_per_case;
        Ploss_woopt(i-1)  = Data{1,2}.Results(i).Ploss_mean;
        costs_diffpar(i-1) = Data{1,3}.Results(i).total_cost_per_case;
        Ploss_diffpar(i-1)  = Data{1,3}.Results(i).Ploss_mean;
        costs_onlyP(i-1) = Data{1,4}.Results(i).total_cost_per_case;
        Ploss_onlyP(i-1)  = Data{1,4}.Results(i).Ploss_mean;
    else
       costs_withopt(i-1) = 0;
       Ploss_withopt(i-1) = 0;
       costs_woopt(i-1) = 0;
       Ploss_woopt(i-1) = 0;
       costs_diffpar(i-1) = 0;
       Ploss_diffpar(i-1)  = 0;
       costs_onlyP(i-1) = 0;
       Ploss_onlyP(i-1)  = 0;
    end
end

%%vars for plot
vcase = 1:25;
green1 = '#04cc82';
red1 = '#cc0000';
darkblue = '#000066';
orange = '#e59400';
cyan = '#00FFFF';
axes_fontsize = 15;
titlesize = 20;

%% plot cost and loss reduction
figure(1)

subplot(121)
ax = gca;
ax.FontSize = axes_fontsize;

hold on
plot(vcase,costs_withopt,'Color',green1)
plot(vcase,costs_woopt,'Color',red1)
plot(vcase,costs_diffpar,'Color',orange)
% plot(vcase,costs_onlyP,'Color',darkblue)
title('Costs With and Without Optimisation','FontSize',titlesize)
xlabel('case')
ylabel('cost [€]')
lgd = legend('Costs with optimisation','Costs without optimisation',...
    'Costs with different parameters','Costs with only P_{loss} optimisation');
lgd.Location = 'northwest';
lgd.FontSize = axes_fontsize;

subplot(122)
ax = gca;
ax.FontSize = axes_fontsize;

hold on
title('P_{loss} With and Without Optimisation','FontSize',titlesize)
plot(vcase,Ploss_withopt,'Color',green1)
plot(vcase,Ploss_woopt,'Color',red1)
plot(vcase,Ploss_diffpar,'Color',orange)
plot(vcase,Ploss_onlyP,'Color',darkblue)
xlabel('case')
ylabel('P_{loss} [MW]')
lgd = legend('P_{loss} with optimisation','P_{loss} without optimisation',...
    'P_{loss} with different parameters','P_{loss} with only P_{loss} optimisation');
lgd.Location = 'northwest';
lgd.FontSize = axes_fontsize;

%% cumulative cost
days = 0:365;
factor = 24/(25*0.25); %25 cases to day

total_costs_withopt = sum(costs_withopt);
total_costs_diffpar = sum(costs_diffpar);
total_costs_woopt = sum(costs_woopt);

total_costs_withopt_cum = zeros(1,length(days));
total_costs_diffpar_cum = zeros(1,length(days));
total_costs_woopt_cum = zeros(1,length(days));
 
for i = 2:length(days)
    total_costs_withopt_cum(i) = total_costs_withopt_cum(i-1) + total_costs_withopt * factor;
    total_costs_diffpar_cum(i) = total_costs_diffpar_cum(i-1) + total_costs_diffpar * factor;
    total_costs_woopt_cum(i) = total_costs_woopt_cum(i-1) + total_costs_woopt * factor;
end

total_savings_cum = total_costs_woopt_cum-total_costs_withopt_cum;

fig = figure(2);
set(fig,'defaultAxesColorOrder',[0, 0, 0;0, 0, 0]);
hold on
title('Cumulative Costs in a Year','FontSize',titlesize)
xlabel('days')

yyaxis left
plot(days,total_costs_withopt_cum,'-','Color',green1)
plot(days,total_costs_woopt_cum,'-','Color',red1)
plot(days,total_costs_diffpar_cum,'Color',orange)

ylabel('cumulative cost [€]')

yyaxis right
% plot(days,total_savings_cum,'-','Color',darkblue)
ylabel('cumulative savings [€]')

ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Costs with optimisation','Costs without optimisation','Cumulative savings');
lgd.Location = 'northwest';
lgd.FontSize = axes_fontsize;
