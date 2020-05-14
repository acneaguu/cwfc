%%This function is used to initialise the system topology and powerflow
%%options. The option variable is used to specify which topology is used:
%%1 for system 41
%%2 for system 13 i.e. WPZ topology
function initialise_systemdata(topology)
%%surpress MATPOWER outputs
global mpopt Systemdata CONSTANTS Optimisation
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
Systemdata.wtg_pos = logical([0; ones(Optimisation.Nturbines,1); ...
    zeros(Optimisation.Npv,1)]); 
                                            %logic vector with 1 on wtg
                                            %positions in gen matrix
Systemdata.pvg_pos = logical([zeros(Optimisation.Nturbines+1,1); ...
    ones(Optimisation.Npv,1)]);
                                            %logic vector with 1 on pvg
                                            %positions in gen matrix
Systemdata.trans = Systemdata.mpc.branch(:,CONSTANTS.ANGMAX) ~= 0;
Systemdata.shunts = Systemdata.mpc.bus(:,CONSTANTS.BS)~= 0;

end
