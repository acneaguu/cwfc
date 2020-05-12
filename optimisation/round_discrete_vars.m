%%This function is used to round the varianles of 'Xin  specified by the
%%logic vector 'which_vars' to the nearest multiples of the values
%%specified in 'range_vars'. 'range_vars' must have the length of
%%'which_vars'. If 'range_vars' is empty, then the variables in
%%'which_vars' are rounded to the nearest integer
function Xout = round_discrete_vars(Xin,which_vars,range_vars)
    Xout = Xin;
    if nargin > 2
        Xout(which_vars) = range_vars(which_vars) .* floor(Xin(which_vars)./range_vars(which_vars));
    else 
        Xout(which_vars) = round(Xin(which_vars));
    end
end