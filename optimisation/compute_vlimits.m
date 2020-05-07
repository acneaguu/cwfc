function vlimits = compute_vlimits(Qpcc)

if Qpcc > 1
    Qpcc = 0.99;
end
if Qpcc < -1
    Qpcc = -0.99;
end
%%corner coordinates of QV region
x = [-0.25 1 1 0 -1 -1];
y = [0.9 0.9 1 1.1 1.1 1];

%%make shape
shape = polyshape(x,y);
line = [Qpcc 0.8; Qpcc 1.2];
[int] = intersect(shape,line);
vlimits = flip(transpose(int(:,2)));
end