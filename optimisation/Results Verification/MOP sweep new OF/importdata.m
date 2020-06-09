clear all
close all

filelist = dir('*.mat');

for i = 1:length(filelist(:,1))
    Datakk{i} = load(filelist(i,1).name,'Data');
end

for i = 1:19
    costs_w005(i) = Datakk{1,1}.Data{1,i}.total_costs;
    w1_005(i) = Datakk{1,1}.Data{1,i}.Optimisation.w1;
    w2_005(i) = Datakk{1,1}.Data{1,i}.Optimisation.w2;
    w3_005(i) = Datakk{1,1}.Data{1,i}.Optimisation.w3;
    w4_005(i) = Datakk{1,1}.Data{1,i}.Optimisation.w4;
    for j = 2:5
        reactorchanges_005(j-1,i) = Datakk{1,1}.Data{1,i}.Results(j).Reactors_changes(2);
        qdistance_005(j-1,i) = Datakk{1,1}.Data{1,i}.Results(j).extremeness_setpoints(2);
    end
end
for i = 1:17
    costs_w010(i) = Datakk{1,2}.Data{1,i}.total_costs; 
    w1_010(i) = Datakk{1,2}.Data{1,i}.Optimisation.w1;
    w2_010(i) = Datakk{1,2}.Data{1,i}.Optimisation.w2;
    w3_010(i) = Datakk{1,2}.Data{1,i}.Optimisation.w3;
    w4_010(i) = Datakk{1,2}.Data{1,i}.Optimisation.w4;
    for j = 2:5
        reactorchanges_010(j-1,i) = Datakk{1,2}.Data{1,i}.Results(j).Reactors_changes(2);
        qdistance_010(j-1,i) = Datakk{1,2}.Data{1,i}.Results(j).extremeness_setpoints(2);
    end
end

for i = 1:29
    costs_w015(i) = Datakk{1,3}.Data{1,i}.total_costs; 
    w1_015(i) = Datakk{1,3}.Data{1,i}.Optimisation.w1;
    w2_015(i) = Datakk{1,3}.Data{1,i}.Optimisation.w2;
    w3_015(i) = Datakk{1,3}.Data{1,i}.Optimisation.w3;
    w4_015(i) = Datakk{1,3}.Data{1,i}.Optimisation.w4;
    for j = 2:5
        reactorchanges_015(j-1,i) = Datakk{1,3}.Data{1,i}.Results(j).Reactors_changes(2);
        qdistance_015(j-1,i) = Datakk{1,3}.Data{1,i}.Results(j).extremeness_setpoints(2);
    end
end


for i = 1:13
    costs_w020(i) = Datakk{1,4}.Data{1,i}.total_costs; 
    w1_020(i) = Datakk{1,4}.Data{1,i}.Optimisation.w1;
    w2_020(i) = Datakk{1,4}.Data{1,i}.Optimisation.w2;
    w3_020(i) = Datakk{1,4}.Data{1,i}.Optimisation.w3;
    w4_020(i) = Datakk{1,4}.Data{1,i}.Optimisation.w4;
    for j = 2:5
        reactorchanges_020(j-1,i) = Datakk{1,4}.Data{1,i}.Results(j).Reactors_changes(2);
        qdistance_020(j-1,i) = Datakk{1,4}.Data{1,i}.Results(j).extremeness_setpoints(2);
    end
end

for i = 1:11
    costs_equal(i) = Datakk{1,5}.Data{1,i}.total_costs; 
    w1_equal(i) = Datakk{1,5}.Data{1,i}.Optimisation.w1;
    w2_equal(i) = Datakk{1,5}.Data{1,i}.Optimisation.w2;
    w3_equal(i) = Datakk{1,5}.Data{1,i}.Optimisation.w3;
    w4_equal(i) = Datakk{1,5}.Data{1,i}.Optimisation.w4;
    for j = 2:5
        reactorchanges_equal(j-1,i) = Datakk{1,5}.Data{1,i}.Results(j).Reactors_changes(2);
        qdistance_equal(j-1,i) = Datakk{1,5}.Data{1,i}.Results(j).extremeness_setpoints(2);
    end
end

for i = 1:5
    costs_equal_mr(i) = Datakk{1,6}.Data{1,i}.total_costs; 
    w1_equal_mr(i) = Datakk{1,6}.Data{1,i}.Optimisation.w1;
    w2_equal_mr(i) = Datakk{1,6}.Data{1,i}.Optimisation.w2;
    w3_equal_mr(i) = Datakk{1,6}.Data{1,i}.Optimisation.w3;
    w4_equal_mr(i) = Datakk{1,6}.Data{1,i}.Optimisation.w4;
    for j = 2:5
        reactorchanges_equal_mr(j-1,i) = Datakk{1,6}.Data{1,i}.Results(j).Reactors_changes(2);
        qdistance_equal_mr(j-1,i) = Datakk{1,6}.Data{1,i}.Results(j).extremeness_setpoints(2);
    end
end


for i = 1:17
    costs_w3stw4(i) = Datakk{1,7}.Data{1,i}.total_costs; 
    w1_w3stw4(i) = Datakk{1,7}.Data{1,i}.Optimisation.w1;
    w2_w3stw4(i) = Datakk{1,7}.Data{1,i}.Optimisation.w2;
    w3_w3stw4(i) = Datakk{1,7}.Data{1,i}.Optimisation.w3;
    w4_w3stw4(i) = Datakk{1,7}.Data{1,i}.Optimisation.w4;
    for j = 2:5
        reactorchanges_w3stw4(j-1,i) = Datakk{1,7}.Data{1,i}.Results(j).Reactors_changes(2);
        qdistance_w3stw4(j-1,i) = Datakk{1,7}.Data{1,i}.Results(j).extremeness_setpoints(2);
    end
end

tot_reactorchanges_005 = sum(reactorchanges_005);
tot_reactorchanges_010 = sum(reactorchanges_010);
tot_reactorchanges_015 = sum(reactorchanges_015);
tot_reactorchanges_020 = sum(reactorchanges_020);

dualplot = 0;

figure
if dualplot ~= 1
    subplot(321)
    hold on
    title('w_{3} and w_{4} = 0.05')
    plot(w1_005,costs_w005)
    xlabel('w_{1}')
    ylabel('Cost [€]')   
end

if dualplot ~= 1
   subplot(322)
else
    subplot(121)
end
hold on
title('w_{3} and w_{4} = 0.10')
plot(w1_010,costs_w010)
xlabel('w_{1}')
ylabel('Cost [€]')

if dualplot ~= 1
   subplot(323)
else
    subplot(122)
end
hold on
title('w_{3} and w_{4} = 0.15')
plot(w1_015,costs_w015)
xlabel('w_{1}')
ylabel('Cost [€]')

if dualplot ~= 1
    subplot(324)
    hold on
    title('w_{3} and w_{4} = 0.20')
    plot(w1_020,costs_w020)
    xlabel('w_{1}')
    ylabel('Cost [€]')

    subplot(325)
    hold on
    title('w_{3} = 0.05 and w_{4} = 0.15')
    plot(w1_w3stw4,costs_w3stw4)
    xlabel('w_{1}')
    ylabel('Cost [€]')
end

figure(2)
% subplot(121)
% hold on
% title('w_{1} and w_{2} equal and w_{3} and w_{4} equal')
% plot(w3_equal,costs_equal)
% xlabel('w_{3}')
% ylabel('Cost [€]')
% 
% subplot(122)
hold on
title({'w_{1} and w_{2} equal and w_{3} and w_{4} equal';'multiple runs'})
plot(w3_equal_mr,costs_equal_mr)
xlabel('w_{3}')
ylabel('Cost [€]')



