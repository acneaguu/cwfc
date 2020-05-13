%%This function is used to initialise the system topology and powerflow
%%options
function initialise_systemdata(topology)
%%surpress MATPOWER outputs
global mpopt Systemdata
mpopt = mpoption('verbose',0,'out.all',0);
%%Structure containing power system and optimization related information
Systemdata.mpc = topology;
Systemdata.Nbranch = size(Systemdata.mpc.branch,1);
Systemdata.Nbus = size(Systemdata.mpc.bus,1);
Systemdata.Nstring = size(Systemdata.mpc.gen,1);
Systemdata.strings = find(Systemdata.mpc.bus(:,CONSTANTS.PG));
Systemdata.trans = find(Systemdata.mpc.branch(:,CONSTANTS.ANGMAX));
Systemdata.shunts = find(Systemdata.mpc.bus(:,CONSTANTS.BS));

end
