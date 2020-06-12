for i = 2:7
    stdQ(i-1) = mean(std(Results(i).Xbest(2:end,1:17),1));
end