clear all
close all

filelist = dir('*.mat');

for i = 1:length(filelist(:,1))
    Datakk{i} = load(filelist(i,1).name,'Data');
end

for i = 1:20
    costw3_005(i) = Datakk{1,1}.Data{1,i}.total_costs;
    costw3_010(i) = Datakk{1,2}.Data{1,i}.total_costs;
    costw3_015(i) = Datakk{1,3}.Data{1,i}.total_costs;
    costw3_020(i) = Datakk{1,4}.Data{1,i}.total_costs;
end