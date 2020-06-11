clear all;

profile = readtable('solar_profile.csv');
wind_speed = table2array(profile(1:8784,6));
solar_irr = table2array(profile(1:8784,3));

[max_irr max_solind] = max(solar_irr);
[max_ws max_wsind] = max(wind_speed);

kk = sum(find(wind_speed>7));