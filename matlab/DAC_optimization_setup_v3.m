tic
k = 9;
buff_highest_SNDR = zeros(1,8);
a = DAC_fns(k, 0, 0);
% Constant_E = a.energy_prox([11e-15 11e-15]);
Constant_E = 12e-12;
sam_p = 1e2;
% a.set_Ebudget(Constant_E);
for k = 2:9
    a = DAC_fns(k, Constant_E, 0);
    endpoints = a.get_endpoints;
    fine_Cu = linspace(endpoints(1,2), endpoints(2,2), sam_p);
    buff_coarse = zeros(1,sam_p);


        for i = 1:sam_p
            buff_coarse(i) = a.get_coarse_Cu(Constant_E, fine_Cu(i));
    %         a.energy_prox([buff_coarse(i) fine_Cu(i)])
        end
    %     contour{j} = buff_coarse;

    % end
    buff_FOM = zeros(1,sam_p);
    for i = 1:sam_p
        buff_FOM(i) = a.FOM_prox([buff_coarse(i) fine_Cu(i)]);
    end
    buff_highest_FOM(k-1) = max(buff_FOM)
    index = find(buff_FOM == max(buff_FOM));
    coarse = buff_coarse(index)
    fine = fine_Cu(index)
end
buff_highest_FOM
max(buff_highest_FOM)
best_k = find(buff_highest_FOM == max(buff_highest_FOM)) + 1
toc
