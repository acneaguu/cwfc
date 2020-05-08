function savedata
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results Keeptrack FCount;
    
    rundata = sprintf('Nruns=%3.1d_Nvars=%3.1d',Optimisation.Nruns,Optimisation.Nvars);
    namestr = strcat(rundata,'_',datestr(now,'dd-MM-yyyy HH-mm-ss'));
    save(namestr)
end