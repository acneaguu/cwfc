function update_casefile(Xin)
global Systemdata
if Systemdata.which_topology == 1
    Systemdata.mpc.bus(24:end,4) = Xin(np,18).';
    Systemdata.mpc.branch(1,9) = Xin(np,19); %change tf ratio 
    Systemdata.mpc.branch(13,9) = Xin(np,20);
    Systemdata.mpc.bus(2,CONSTANTS.BS) = Xin(np,21);%Changes inductor
    Systemdata.mpc.bus(5,CONSTANTS.BS) = Xin(np,22);%Changes capacitor
end



end