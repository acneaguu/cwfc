%%This function returns a vector which contains a logic vector
%with a 1 at the rows which contain optimisation variables, i.e
%transformers and shunts
function g = find_indeces()
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results; 

g.strings = zeros(Systemdata.Nstrings,1);
g.trans = zeros(Systemdata.Nbranch,1);
g.shunts = zeros(Systemdata.Nbus,1);

g.strings = find(Systemdata.mpc.bus(:,CONSTANTS.PG));
g.trans = find(Systemdata.mpc.branch(:,CONSTANTS.ANGMAX));
g.shunts = find(Systemdata.mpc.bus(:,CONSTANTS.BS));

end