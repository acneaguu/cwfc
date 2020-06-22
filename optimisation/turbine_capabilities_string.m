clear all
close all

stepsize = 0.1;
vmin = 0;
vmax = 30;
v = vmin:stepsize:vmax;
[P,Q] = compute_pq_wtg_string(7);
endsamp_string = 25/stepsize + 1;
% figure(1)
% plot(P(:,1),Q(:,1))
L = length(P(1,:));
for i = 1:L
% figure(1)
% subplot(4,4,i)
% plot(P(1:endsamp_string,i),Q(1:endsamp_string,i))    
% xlabel('P [MW]','FontSize',8)
% ylabel('Q [MVAr]','FontSize',8)


% figure(2)
% subplot(4,4,i)
% plot(v,P(:,i))
% xlabel('windspeed [m/s]','FontSize',8)
% ylabel('P [MW]','FontSize',8)


figure(3)
subplot(2,2,i)
plot(v,Q(:,i))
if(i==1)
title('EP3 E138 4.2 MW FTQ (A)', 'FontSize',12);
end
if(i==2)
title('EP3 E126 4.0 MW FT (B)', 'FontSize',12);
end
if(i==3)
title('EP3 E115 4.0 MW FT(C)', 'FontSize',12);
end
if(i==4)
title('EP3 E103 2.35 MW FT(D)','FontSize',12);
end
xlabel('windspeed [m/s]','FontSize',12)
ylabel('Q [MVAr]','FontSize',12)
end