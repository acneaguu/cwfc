function [Ptot,Qtot] = compute_pq_pvg(irradiance,Nstrings)
    %%parameters
    %module specs
    area_module = 1.046*1.558;
    effiency_module = 0.221;
    Nmodules_per_string = 41667;
    Prated = 360;
    %inverter specs
    efficiency_inverter = 0.95;
    Qrange = 1/3;
    
    %%compute P and Q 
    P = irradiance * effiency_module * area_module;               
    if P > Prated
        P = Prated;
    end
    Ptot = P * Nmodules_per_string* efficiency_inverter * 1e-6; %P in MW per string   
    Qtot = Qrange * Ptot;                                          %Q in MVAr per string
    
    %%repeat for N strings
    Ptot = repmat(Ptot,1,Nstrings);
    Qtot = repmat(Qtot,1,Nstrings);
end