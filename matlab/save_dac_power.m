tic
cs_coarse = {};
cs_fine = {};
for k = 1:9
    a = ADC(10, k, k, 'CS_DAC',1,'CS_DAC',1, 0, 0, 0, 0);
    %    coarse_buff = a.get_coarse_DAC_Energy;
    %    fine_buff = a.get_fine_DAC_Energy;
    cs_coarse{k} = a.get_coarse_DAC_Energy;
    cs_fine{k} = a.get_fine_DAC_Energy;
%    label = ['cs_coarse_energy_k' num2str(k) '.mat'];
%    save(label, 'coarse_buff')
%    label = ['cs_fine_energy_k' num2str(k) '.mat'];
%    save(label, 'fine_buff')
end
toc

save('cs_energy_k.mat')