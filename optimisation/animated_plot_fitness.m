%%The name of the datastruct is used to load the data for the plot
%%The struct should contain a variable F which is used to plot the fitness
%%and a matrix X which is used to plot F as a function of up to 2
%%optimisation variables. With the input 'vars', the position of the
%%columns of the two variables is specified
function animated_plot_fitness(X,F,vars)
drawrate = 1/144;
h = animatedline('Color','red','LineWidth',2);

nfig = get(gcf,'Number');
if nfig > 1
    figure(nfig+1)
else 
    figure(1)
end

if nargin>2
    if length(vars) > 1
        x1 = X(:,vars(1));
        x2 = X(:,vars(2));
        axis([min(x1),max(x1),min(x2),max(x2),0,3*F(end)])
        view([45 45])
        drawtype = 2;
    else
        x1 = X(:,vars(1));
        axis([0.9*min(x1),1.1*max(x1),0,3*F(end)])
        drawtype = 1;
    end
else
    x1 = 1:length(F);
    ylim(F(end)*[0.99,1.01])
    drawtype = 1;
end 
   
a = tic;
for k = 1:length(x1)
    switch drawtype
        case 2
            addpoints(h,x1(k),x2(k),F(k)); 
        case 1 
            addpoints(h,x1(k),F(k));
    end
    b = toc(a);
    if b > drawrate
      drawnow
      a = tic;
    end
end
drawnow
end