summ = 0;
N = 0;
for i = 2:21
    if Results(i).Times_converged == 10
        summ = summ + Results(i).Ploss_mean;
        N = N + 1;
    end
end
meanloss = summ/N;