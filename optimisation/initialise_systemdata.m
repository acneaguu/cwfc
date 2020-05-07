function initialise_systemdata()
%%surpress MATPOWER outputs
global mpopt Optimisation Systemdata
mpopt = mpoption('verbose',0,'out.all',-1);

%%Structure containing power system and optimization related information
%That is, 
Systemdata.mpc = system_41();
Systemdata.mpc.bus(24:end,4) = rand(18,1);%random MVAr
Systemdata.Nbranch = size(Systemdata.mpc.branch,1);
Systemdata.Nbus = size(Systemdata.mpc.bus,1);
end