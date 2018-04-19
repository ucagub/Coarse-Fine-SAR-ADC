cs_coarse = {};
cs_fine = {};
for k = 1:9
    b = ADC(10, k, k, 'CS_DAC', 1, 'CS_DAC', 1, 0, 0, 0, 0);
    b.disp_Emean
    cs_coarse{k} = mean(b.get_coarse_DAC_Energy);
    cs_fine{k} = mean(b.get_fine_DAC_Energy);
end





save('cs_energy_k.mat','cs_coarse','cs_fine');