function mpc = test_sys41()
global mpopt CONSTANTS;

ntest = 1;
mpc = system_41();
nturbines = 18;

for i = 1:ntest
    mpc.bus(24:end,4) = rand(nturbines,1) .* 1;%random MVAr
%     tic 
%     PFresults = runpf(mpc,mpopt);
%     time(i) = toc;
end
% 
% maxtime = max(time);
% avgtime = mean(time);

%%check for limit violations
%%Fv contains branch flow limits violations
%%Pv contains generator active power limits violations
%%Qv contains generator reactive power limits violations
%%Vv coontains bus voltage limits violations


%[lim.Fv, lim.Pv, lim.Qv, lim.Vv] = checklimits(PFresults); 

%%test with opf
% PF_optmat = runopf(mpc);
% checklimits(PF_optmat);
end