function [Data,Solution] = import_results
    filelist = dir('*.mat');
    
    for i = 1:length(filelist(:,1))
        load(filelist(i,1).name);
        
        Data(i,1) = parameter.fs_factor_start;
        Data(i,2) = parameter.fs_factor_end;
        Data(i,3) = parameter.n_random_ini;
        Data(i,4) = parameter.n_random_last;
        Data(i,5) = Results(2).best_run_fitness;
        Data(i,6) = Results(3).best_run_fitness;
        Data(i,7) = Results(4).best_run_fitness;
        Solution(i).best_run_fitness1 = Results(2).best_run_fitness;
        Solution(i).best_run_fitness2 = Results(3).best_run_fitness;
        Solution(i).best_run_fitness3 = Results(4).best_run_fitness;
        Solution(i).best_run_solution1 = Results(2).best_run_solution;
        Solution(i).best_run_solution2 = Results(3).best_run_solution;
        Solution(i).best_run_solution3 = Results(4).best_run_solution;
    end

end