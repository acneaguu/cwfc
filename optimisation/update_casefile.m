function update_casefile(Xin,mode)
global Systemdata CONSTANTS Optimisation;

%%check if sum of the logic vectors indicating wtg/solar/tr taps/reactor = 
%%number of variables in X

%%if so, update the casefile as follows:
if mode == 1        %updates the controllable variables
    Systemdata.mpc.gen(Systemdata.wtg_pos,CONSTANTS.QG:CONSTANTS.QMIN) = ...
        repmat(transpose(Xin(Optimisation.wtg_pos)),1,3);
    
    Systemdata.mpc.gen(Systemdata.pvg_pos,CONSTANTS.QG:CONSTANTS.QMIN) = ....
        repmat(transpose(Xin(Optimisation.pvg_pos)),1,3);
    %%Updates transformer tap positions
    Systemdata.mpc.branch(Systemdata.trans,CONSTANTS.TAP) = Xin(Optimisation.tr_pos);
    %%Updates reactor status: bustype and branch status
    Systemdata.mpc.bus(Systemdata.shunts,CONSTANTS.BUS_TYPE) = ...
        Xin(Optimisation.r_pos)*3+1; 
%     Systemdata.mpc.branch(Systemdata.shuntbranch,CONSTANTS.BR_STATUS) = ...
%         Xin(Optimisation.r_pos);
elseif mode == 2    %updates the active power
    Systemdata.mpc.gen(index_wtg,[2 9:10]) = repmat(transpose(Xin),1,3);
% elseif mode == 3    %legacy for system 41
%     Systemdata.mpc.bus(24:end,4) = Xin(np,18).';
%     Systemdata.mpc.branch(1,9) = Xin(np,19); %change tf ratio 
%     Systemdata.mpc.branch(13,9) = Xin(np,20);
%     Systemdata.mpc.bus(2,CONSTANTS.BS) = Xin(np,21);%Changes inductor
%     Systemdata.mpc.bus(5,CONSTANTS.BS) = Xin(np,22);%Changes capacitor
end


end