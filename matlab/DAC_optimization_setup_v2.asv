tic
k = 9;
buff_highest_SNDR = zeros(1,8);
a = DAC_fns(9, 0, 0);
Constant_E = a.energy_prox([11e-15 11e-15]);
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
    buff_SNDR = zeros(1,sam_p);
    for i = 1:sam_p
        buff_SNDR(i) = a.SNDR_prox([buff_coarse(i) fine_Cu(i)]);
    end
    buff_highest_SNDR(k-1) = max(buff_SNDR)
    index = find(buff_SNDR == max(buff_SNDR));
    coarse = buff_coarse(index)
    fine = fine_Cu(index)
end
buff_highest_SNDR
max(buff_highest_SNDR)
best_k = find(buff_highest_SNDR == max(buff_highest_SNDR)) + 1
toc

