%%This function is used to save the workspace. It is possible to specify a
%%prefix which is saved before the rest of the file name. The format is as
%%follows: userstring_With/No Opt_Algorithm name_Number of runs_Number of
%%variables_date + time
function savedata
global CONSTANTS Qref mpopt Systemdata PFresults Optimisation Results Keeptrack FCount;
    name = input('Enter custom prefix:\n','s');
    if or(or(Optimisation.w1,Optimisation.w2),Optimisation.w3)
        optstr = 'With Opt ';
    else
        optstr = 'No Opt ';
    end
    
    if Optimisation.algorithm == 1
        algstr = 'GA_';
    elseif Optimisation.algorithm == 2
        algstr = 'PS_';
    elseif Optimisation.algorithm == 3
        algstr = 'CDEEPSO';
    end
    if isempty(name)
        name = [];
    else
        name = strcat(name,"_");
    end
    rundata = sprintf('Nruns =%3.1d Nvars =%3.1d',Optimisation.Nruns,Optimisation.Nvars);
    namestr = strcat(name,optstr," ",algstr,rundata,"_",datestr(now,'dd-MM-yyyy HH-mm-ss'));
    save(namestr)
end