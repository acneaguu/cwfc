summ = 0;
N = 0;
for i = 2:26
    if Results(i).Times_converged == 5
        summ = summ + Results(i).Ploss_mean;
        N = N + 1;
    end
end
meanloss = summ/N;