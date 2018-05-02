tic
% k=2
sam_p = 200;
coarse_Cu = linspace(10e-15, 70e-15, sam_p);
fine_Cu = linspace(10e-15, 22e-15, sam_p);
min_walden_FOM_k = zeros(1,9);
%coarse fine
max_Cus = zeros(9,2);
parfor k = 1:9
    
    min_walden_FOM = 0;
    min_coarse_Cu = 0;
    min_fine_Cu = 0;
    a = DAC_fns(k, 0, 0);
    
    for j =1:sam_p
        for i = 1:sam_p
            buff_FOM = a.FOM_walden_prox([coarse_Cu(i) fine_Cu(j)]);
            if buff_FOM > min_walden_FOM
                min_walden_FOM = buff_FOM;
                min_coarse_Cu = coarse_Cu(i);
                min_fine_Cu = fine_Cu(j);
            end
        end
    end
    min_walden_FOM_k(k) = min_walden_FOM;
    max_Cus(k,:) = [min_coarse_Cu min_fine_Cu];
end
% max_FOM
% max_coarse_Cu
% max_fine_Cu

best_k = find(min_walden_FOM_k == min(min_walden_FOM_k)) 

toc
