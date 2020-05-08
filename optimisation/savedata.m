function savedata
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results Keeptrack FCount;
    if or(or(Optimisation.w1,Optimisation.w2),Optimisation.w3)
        optstr = 'With Opt ';
    else
        optstr = 'No Opt ';
    end
    
    if Optimisation.algorithm == 1
        algstr = 'GA_';
    elseif Optimisation.algorithm == 2
        algstr = 'PS_';
    end
    
    rundata = sprintf('Nruns =%3.1d Nvars =%3.1d',Optimisation.Nruns,Optimisation.Nvars);
    namestr = strcat(optstr," ",algstr,rundata,"_",datestr(now,'dd-MM-yyyy HH-mm-ss'));
    save(namestr)
end