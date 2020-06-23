clear all
close all

filelist = dir('*.mat');

for i = 1:6
    
    Data{i} = load(filelist(i,1).name,'Results');
end
% 
% Results_no_opt(1:6) = Data{1,2}.Results;
% Results_no_opt(7:26) = Data{1,1}.Results(7:26);
% Results_opt(1:6) = Data{1,4}.Results;
% Results_opt(7:26) = Data{1,3}.Results(2:21);

for i = 2:26
   Data{1,2}.Results(i).total_cost_per_case = min(Data{1,2}.Results(i).total_cost_per_run(2:6));
   Data{1,3}.Results(i).total_cost_per_case = min(Data{1,3}.Results(i).total_cost_per_run(2:6));
   Data{1,4}.Results(i).total_cost_per_case = min(Data{1,4}.Results(i).total_cost_per_run(2:6));
   Data{1,5}.Results(i).total_cost_per_case = min(Data{1,5}.Results(i).total_cost_per_run(2:6));
end    
    
    
Results_no_opt = Data{1,1}.Results;
Results_opt = Data{1,2}.Results;
Results_turbinelevel_with_opt = Data{1,3}.Results;
Results_opt_tuned = Data{1,4}.Results;
Results_opt_equal_ws = Data{1,5}.Results;
Results_turbinelevel_no_opt = Data{1,6}.Results;


for i = 2:length(Results_opt)

        if Results_no_opt(i).Times_converged >= 5
            costs_no_opt(i-1) =  Results_no_opt(i).total_cost_per_case;
            costs_with_opt(i-1) = Results_opt(i).total_cost_per_case;
            costs_with_optpar(i-1) = Results_opt_tuned(i).total_cost_per_case;
            cost_with_opt_turbinelevel(i-1) = Results_turbinelevel_with_opt(i).total_cost_per_case;
            cost_equalw(i-1) = Results_opt_equal_ws(i).total_cost_per_case;
            cost_no_opt_turbinelevel(i-1) = Results_turbinelevel_no_opt(i).total_cost_per_case;
            
%             cost_reduction(i-1) = costs_no_opt(i-1)-costs_with_opt(i-1);
            cost_reduction(i-1) = cost_no_opt_turbinelevel(i-1)-cost_with_opt_turbinelevel(i-1);
            
            
%             reduction_improvement(i-1) = costs_with_opt(i-1)- cost_turbinelevel(i-1); 
            reduction_improvement(i-1) = cost_with_opt_turbinelevel(i-1)- cost_equalw(i-1); 
%             reduction_improvement(i-1) = Results_opt(i).best_run_fitness - Results_turbinelevel(i).best_run_fitness; 
            
        end
end


cases = linspace(1,25,25);

whichcase = 1:25;
darkblue = '#000066';
blue = '#0000ff';
lightblue = '#00ffff';
darkblue2 =  '#000033';

fig1 = figure(1);
left_col = [0 0 0];
right_col = [0/255 128/255 0];
set(fig1,'defaultAxesColorOrder',[left_col;left_col]);
hold on
xlabel('Case')
yyaxis left
plot(cases(1:24),cost_no_opt_turbinelevel(1:24),'-o','Color','red','MarkerSize',3);
plot(cases(1:24),cost_with_opt_turbinelevel(1:24),'-o','Color','blue','MarkerSize',3); 
ylabel('Costs [€]');
% title('Costs: No Optimisation vs Optimisation','FontSize',20);

yyaxis right
plot(cases(1:24),cost_reduction(1:24),'-o','Color',right_col,'MarkerSize',3);
ylabel('Cost Reduction [€]');


axes_fontsize = 15;
ax1 = gca;
ax1.FontSize = axes_fontsize;
lgd1 = legend('Without optimisation','With optimisation','Feasibility of optimisation');
lgd1.FontSize = 15;
lgd1.Location = 'northwest';


fig2 = figure(2);
set(fig2,'defaultAxesColorOrder',[left_col;left_col]);
hold on
xlabel('Case')
yyaxis left
plot(cases(1:24),costs_with_opt(1:24),'-o','Color','red','MarkerSize',3);
plot(cases(1:24),cost_equalw(1:24),'-o','Color','blue','MarkerSize',3); 
ylabel('Costs [€]');
% title('Tuning Comparison: Before vs After ','FontSize',20);

yyaxis right
plot(cases(1:24),reduction_improvement(1:24),'-o','Color',right_col,'MarkerSize',3);
ylabel('Cost Improvement [€]');

axes_fontsize = 15;
ax2 = gca;
ax2.FontSize = axes_fontsize;
lgd2 = legend('String level','Turbine level','Improvement');
lgd2.FontSize = 15;
lgd2.Location = 'northwest';
        