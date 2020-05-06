function Xout = round_discrete_vars(Xin,which_vars)
    which_vars = which_vars == 1;
    Xout = Xin;
    Xout(which_vars) = round(Xin(which_vars));
end