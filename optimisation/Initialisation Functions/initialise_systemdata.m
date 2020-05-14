%%This function is used to initialise the system topology and powerflow
%%options. The option variable is used to specify which topology is used:
%%1 for system 41
%%2 for system 13 i.e. WPZ topology
function initialise_systemdata(topology,option)
%%surpress MATPOWER outputs
global mpopt Systemdata CONSTANTS
mpopt = mpoption('verbose',0,'out.all',0);
%%Structure containing power system and optimization related information
Systemdata.mpc = topology;
% if option == 1      %system 41
%     Systemdata.mpc.bus(24:end,4) = rand(18,1);%random MVAr
%     Systemdata.which_topology = 1;
% elseif option == 2  %system 13
%     Systemdata.which_topology = 2;
%     %%blablabla
% end
Systemdata.Nbranch = size(Systemdata.mpc.branch,1);
Systemdata.Nbus = size(Systemdata.mpc.bus,1);
Systemdata.Nstring = size(Systemdata.mpc.gen,1);
Systemdata.strings = find(Systemdata.mpc.bus(:,CONSTANTS.PG));
Systemdata.trans = find(Systemdata.mpc.branch(:,CONSTANTS.ANGMAX));
Systemdata.shunts = find(Systemdata.mpc.bus(:,CONSTANTS.BS));

end
