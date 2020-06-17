x1 = linspace(0,2*pi,1000);
x2 = x1 + deg2rad(120);
x3 = x1 + deg2rad(-120);

P1 = 1+sin(x1);
P2 = 1+sin(x2);
P3 = 1+sin(x3);


Ptot = P1 + P2 + P3;

figure
hold on
plot(x1,P1,'red')
plot(x1,P2,'blue')
plot(x1,P3,'green')
plot(x1,Ptot,'black')
legend('0 degree','120 degree','-120 degree','P_{tot}')