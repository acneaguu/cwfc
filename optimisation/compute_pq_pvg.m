function [P,Q] = compute_pq_pvg(irradiance,Nstrings)
    %%parameters
    %module specs
    area_module = 1.046*1.558;
    effiency_module = 0.228;
    Nmodules_per_string = 41667;
    %inverter specs
    efficiency_inverter = 0.95;
    Qrange = 1/3;
    
    %%compute P and Q 
    P = irradiance * effiency_module * (area_module * Nmodules_per_string)...
        * efficiency_inverter * 1e-6;              %P in MW per string
    Q = Qrange * P;                                %Q in MVAr per string
    
    %%repeat for N strings
    P = repmat(P,1,Nstrings);
    Q = repmat(Q,1,Nstrings);
end