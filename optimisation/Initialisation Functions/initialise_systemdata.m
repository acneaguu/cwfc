function initialise_systemdata(topology)
%%surpress MATPOWER outputs
global mpopt Systemdata
mpopt = mpoption('verbose',0,'out.all',0);

%%Structure containing power system and optimization related information
%That is, 
Systemdata.mpc = topology;
Systemdata.mpc.bus(24:end,4) = rand(18,1);%random MVAr
Systemdata.Nbranch = size(Systemdata.mpc.branch,1);
Systemdata.Nbus = size(Systemdata.mpc.bus,1);
end