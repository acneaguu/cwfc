function Xout = round_discrete_vars(Xin,which_vars)
    Xout = Xin;
    Xout(which_vars) = round(Xin(which_vars));
end