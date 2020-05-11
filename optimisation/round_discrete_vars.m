%%This function is used to round the varianles of 'Xin  specified by the
%%logic vector 'which_vars' to the nearest integers.
function Xout = round_discrete_vars(Xin,which_vars)
    Xout = Xin;
    Xout(which_vars) = round(Xin(which_vars));
end