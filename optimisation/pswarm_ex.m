fun = @(x)x(1)*exp(-norm(x)^2);
rng default  % For reproducibility
nvars = 2;
x = particleswarm(fun,nvars);