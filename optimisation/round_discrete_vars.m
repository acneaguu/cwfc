%%This function is used to round the discrete variables of 'Xin:
%%-Transformer positions in the solution vector are rounded using
%%lookup tables describing all possible ratios
%%-Reactors are rounded to 1/0 depending on on/off
function Xout = round_discrete_vars(Xin)
global Optimisation Systemdata;
Xout = Xin;
%%Rounds the discrete variables:
%%Transformer positions in the solution vector are rounded using
%%lookup tables describing all possible ratios
%%Reactors are rounded to 1/0 depending on on/off
for i = 1:Optimisation.Nvars
    if Optimisation.discrete(i) & Optimisation.tr_pos(i)
        tri = i - Optimisation.Nturbines - Optimisation.Npv;
        Xout(i) = interp1(Systemdata.trlookup(tri,1:Optimisation.Ntaps(tri,1)),...
        Systemdata.trlookup(tri,1:Optimisation.Ntaps(tri,1)),Xin(i),'nearest');
    elseif Optimisation.discrete(i)& Optimisation.r_pos(i)
        Xout(i) = round(Xin(i));
    end
end    
  
end