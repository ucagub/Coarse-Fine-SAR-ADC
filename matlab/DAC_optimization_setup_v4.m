tic
% k=2
sam_p = 400;
coarse_Cu = linspace(10e-15, 70e-15, sam_p);
fine_Cu = linspace(10e-15, 22e-15, sam_p);
max_FOM_k = zeros(1,9);
%coarse fine
max_Cus = zeros(9,2);
parfor k = 1:9
    
    max_FOM = 0;
    max_coarse_Cu = 0;
    max_fine_Cu = 0;
    a = DAC_fns(k, 0, 0);
    
    for j =1:sam_p
        for i = 1:sam_p
            buff_FOM = a.FOM_prox([coarse_Cu(i) fine_Cu(j)]);
            if buff_FOM > max_FOM
                max_FOM = buff_FOM;
                max_coarse_Cu = coarse_Cu(i);
                max_fine_Cu = fine_Cu(j);
            end
        end
    end
    max_FOM_k(k) = max_FOM;
    max_Cus(k,:) = [max_coarse_Cu max_fine_Cu];
end
% max_FOM
% max_coarse_Cu
% max_fine_Cu

best_k = find(max_FOM_k == max(max_FOM_k)) 

toc
