function [P,Q] = compute_pq_pvg(irradiance)
    effiency_module = 160/1000;
    efficiency_inverter = 0.95;
    
    P = irradiance *effiency_module;

end