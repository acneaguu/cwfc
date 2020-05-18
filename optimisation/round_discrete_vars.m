%%This function is used to round the varianles of 'Xin  specified by the
%%logic vector 'which_vars' to the nearest multiples of the values
%%specified in 'range_vars'. 'range_vars' must have the length of
%%'which_vars'. If 'range_vars' is empty, then the variables in
%%'which_vars' are rounded to the nearest integer
function Xout = round_discrete_vars(Xin)
global Optimisation Systemdata;
Xout = Xin;
%%Rounds the discrete variables:
%%Transformer positions in the solution vector are rounded using
%%lookup tables describing all possible ratios
%%Reactors are rounded to 1/0 depending on on/off
for i = 1:Optimisation.Nvars
    if Optimisation.discrete(i) & Optimisation.tr_pos(i)
        Xout(i) = interp1(Systemdata.trlookup(i-Optimisation.Nturbines-Optimisation.Npv,:),...
        Systemdata.trlookup(i-Optimisation.Nturbines-Optimisation.Npv,:),Xin(i),'nearest');
    elseif Optimisation.discrete(i)& Optimisation.r_pos(i)
        Xout(i) = round(Xin(i));
    end
end    
  
end