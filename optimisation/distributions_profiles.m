clear all
close all

b= 2.54; %shape parameter in p.u., the lower the more uniformly spread, 1.2 is best
a= 7.86;%scale parameter in m/s, the higher the more the probability is spread, 12 is best

v = 0:0.05:25;
pdf_weibull = wblpdf(v,a,b); %Initialise matrix for random wind speed
cdf_weibull = wblcdf(v,a,b);

figure(1)
subplot(121)
plot(v,pdf_weibull)
subplot(122)
plot(v,cdf_weibull)

irradiance = 0:1500;
for i = 1:length(irradiance)
[Ptot(:,i),Qtot(:,i)] = compute_pq_pvg(irradiance(i),4);
end

figure(2)
plot(0:1500,sum(Ptot))
title('P_{solar} for different irradiances')
xlabel('irradiance [W/m^{2}]')
ylabel('P_{solar} per string [MW]')

figure(3)
plot(0:1500,sum(Qtot,1))
title('Q_{solar} for different irradiances')
xlabel('irradiance [W/m^{2}]')
ylabel('Q_{solar} per string [MVAr]')

figure(4)
plot(Ptot(1,:),Qtot(1,:))