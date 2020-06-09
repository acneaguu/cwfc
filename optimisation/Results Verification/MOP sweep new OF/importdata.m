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

figure
subplot(221)
hold on
title('w_{3} and w_{4} = 0.05')
plot(w1_005,costs_w005)


subplot(222)
hold on
title('w_{3} and w_{4} = 0.1')
plot(w1_010,costs_w010)

subplot(223)
hold on
title('w_{3} and w_{4} = 0.15')
plot(w1_015,costs_w015)