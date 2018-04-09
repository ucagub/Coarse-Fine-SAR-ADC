
res = 10;
k = 7;
dac_k = 7;
fine_dac_type = 'CS_DAC';
fine_mismatch = 0.008;
coarse_dac_type = 'CS_DAC';
coarse_mismatch = 0.008;
tic
samples = 1e2;
sam_p = 10;
left_edge = 0.002;
right_edge = 0.012;
buff_curve = zeros(sam_p,sam_p);

buff_coarse_mismatch = linspace(left_edge, right_edge, sam_p);
% buff_fine_mismatch = linspace(left_edge, right_edge, sam_p);
buff_coarse_Cu = [1 50 46 38 32 24 18 12 7 4]*1e-15;
% coarse_noise = (.3712e-03)^2;
% fine_noise = (.1504e-3)^2;
coarse_noise = 0;
fine_noise = 0;

%buffs for cauchy fit

% c_load = linspace(10e-6, 3e-3, sam_p);
c_load = 0.4e-15;
droop = linspace(10e-6, 3e-3, sam_p);
% droop = 0;
buff_a = zeros(1, 10);
% buff_b = zeros(1, sam_p);
time_elapsed = 0;
for j = 0:9
    dac_k = j;
    k = j;
    coarse_Cu = buff_coarse_Cu(j+1);
    buf_droop = 0;
    buf_c_load = c_load;
    
    a = ADC(res, k, dac_k, coarse_dac_type, coarse_Cu, fine_dac_type, 2e-15, coarse_noise, fine_noise, buf_c_load, buf_droop);
    buff_a(j+1) = a.Emean;
end
stem([0:9], buff_a./1e-15)
for j = 0:9
    text(j, buff_a(j+1)/1e-15, num2str(buff_a(j+1)/1e-15),'FontSize', 25)
end
% plot(c_load, buff_a)
toc
