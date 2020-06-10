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
costs_w1_sweep = NaN * ones(3,25);
Ploss_w1_sweep = NaN * ones(3,25);
costs_onlyP = NaN * ones(1,25);
Ploss_onlyP = NaN * ones(1,25);

for i = 2:26
    if i ~= 2&&i ~= 3&&i ~= 7
        costs_withopt(i-1) = Data{1,1}.Results(i).total_cost_per_case;
        Ploss_withopt(i-1) = Data{1,1}.Results(i).Ploss_best;
        costs_woopt(i-1) = Data{1,2}.Results(i).total_cost_per_case;
        Ploss_woopt(i-1)  = Data{1,2}.Results(i).Ploss_mean;
        for j = 3:5
            costs_w1_sweep(j-2,i-1) = Data{1,j}.Results(i).total_cost_per_case;
            Ploss_w1_sweep(j-2,i-1)  = Data{1,j}.Results(i).Ploss_mean;
        end
        costs_onlyP(i-1) = Data{1,6}.Results(i).total_cost_per_case;
        Ploss_onlyP(i-1)  = Data{1,6}.Results(i).Ploss_mean;
    else
       costs_withopt(i-1) = 0;
       Ploss_withopt(i-1) = 0;
       costs_woopt(i-1) = 0;
       Ploss_woopt(i-1) = 0;
       costs_w1_sweep(:,i-1) = 0;
       Ploss_w1_sweep(:,i-1) = 0;
       costs_onlyP(i-1) = 0;
       Ploss_onlyP(i-1)  = 0;
    end
end

%%vars for plot
vcase = 1:25;
green1 = '#04cc82';
red1 = '#cc0000';
orange = '#e59400';
darkblue = '#000066';
blue = '#0000ff';
lightblue = '#00ffff';
darkblue2 =  '#000033';
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
for i = 1:3
    plot(vcase,costs_w1_sweep(i,:))
end
plot(vcase,costs_onlyP,'Color',darkblue)
title('Costs With and Without Optimisation','FontSize',titlesize)
xlabel('case')
ylabel('cost [€]')
lgd = legend('Costs with optimisation','Costs without optimisation',...
    'Costs with w_{1} = 0.6','Costs with w_{1} = 0.7',...
    'Costs with w_{1} = 0.8','Costs with only P_{loss} optimisation');
lgd.Location = 'northwest';
lgd.FontSize = axes_fontsize;

subplot(122)
ax = gca;
ax.FontSize = axes_fontsize;

hold on
title('P_{loss} With and Without Optimisation','FontSize',titlesize)
plot(vcase,Ploss_withopt,'Color',green1)
plot(vcase,Ploss_woopt,'Color',red1)
for j = 1:3
    plot(vcase,Ploss_w1_sweep(j,:),'Color',orange)
end
plot(vcase,Ploss_onlyP,'Color',darkblue)
xlabel('case')
ylabel('P_{loss} [MW]')
lgd = legend('P_{loss} with optimisation','P_{loss} without optimisation',...
    'P_{loss} with different parameters','P_{loss} with only P_{loss} optimisation');
lgd.Location = 'northwest';
lgd.FontSize = axes_fontsize;

%% cumulative cost per day
cases = 0:25;

total_costs_withopt_cum = zeros(1,length(cases)) ;
total_costs_w1_sweep_cum = zeros(3,length(cases));
total_costs_woopt_cum = zeros(1,length(cases));

for i = 2:length(cases)
    total_costs_withopt_cum(i) = total_costs_withopt_cum(i-1) + costs_withopt(i-1);
    total_costs_w1_sweep_cum(:,i) = total_costs_w1_sweep_cum(:,i-1) + costs_w1_sweep(:,i-1);
    total_costs_woopt_cum(i) = total_costs_woopt_cum(i-1) + costs_woopt(i-1);
end
figure(2);
hold on
title('Cumulative Costs in a Year','FontSize',titlesize)
xlabel('days')

plot(cases,total_costs_woopt_cum,'-','Color',red1)
plot(cases,total_costs_w1_sweep_cum(1,:),'-','Color',blue)
plot(cases,total_costs_w1_sweep_cum(2,:),'--','Color',lightblue)
plot(cases,total_costs_w1_sweep_cum(3,:),'-.','Color',darkblue2)
plot(cases,total_costs_withopt_cum,'-','Color',darkblue)

ylabel('cumulative cost [€]')

ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Costs without optimisation',...
    'Costs with w_{1} = 0.6','Costs with w_{1} = 0.7',...
    'Costs with w_{1} = 0.8','Costs with  w_{1} = 0.9');
lgd.Location = 'northwest';
lgd.FontSize = axes_fontsize;

%% cumulative cost per year
days = 0:365;
factor = 24/(25*0.25); %25 cases to day

total_costs_withopt = sum(costs_withopt);
total_costs_w1_sweep = sum(costs_w1_sweep,2);
total_costs_woopt = sum(costs_woopt);

total_costs_withopt_cum = zeros(1,length(days));
total_costs_w1_sweep_cum = zeros(3,length(days));
total_costs_woopt_cum = zeros(1,length(days));
 
for i = 2:length(days)
    total_costs_withopt_cum(i) = total_costs_withopt_cum(i-1) + total_costs_withopt * factor;
    total_costs_w1_sweep_cum(:,i) = total_costs_w1_sweep_cum(:,i-1) + total_costs_w1_sweep .* factor;
    total_costs_woopt_cum(i) = total_costs_woopt_cum(i-1) + total_costs_woopt * factor;
end

total_savings_cum = total_costs_woopt_cum-total_costs_withopt_cum;

fig = figure(3);
set(fig,'defaultAxesColorOrder',[0, 0, 0;0, 0, 0]);
hold on
title('Cumulative Costs in a Year','FontSize',titlesize)
xlabel('days')

yyaxis left
plot(days,total_costs_withopt_cum,'-','Color',green1)
plot(days,total_costs_woopt_cum,'-','Color',red1)
for j = 1:3
    plot(days,total_costs_w1_sweep_cum(j,:),'Color',orange)
end
ylabel('cumulative cost [€]')

yyaxis right
% plot(days,total_savings_cum,'-','Color',darkblue)
ylabel('cumulative savings [€]')

ax = gca;
ax.FontSize = axes_fontsize;
lgd = legend('Costs with optimisation','Costs without optimisation',...
    'Costs with w_{1} = 0.6','Costs with w_{1} = 0.7',...
    'Costs with w_{1} = 0.8','Costs with only P_{loss} optimisation','Cumulative savings');
lgd.Location = 'northwest';
lgd.FontSize = axes_fontsize;
