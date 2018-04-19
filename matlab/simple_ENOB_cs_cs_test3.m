
res = 10;
fine_dac_type = 'CS_DAC';
coarse_dac_type = 'CS_DAC';

samples = 10;
time_elapsed = 0;
% fine_Cu = e-15;sim
k=5
tic
buffy = zeros([1 16]);
fine_Cu = [15:15-1+16]*1e-15;
for i = 1:16
    c = ADC(res, k, k, 'CS_DAC', 50e-15, 'CS_DAC', fine_Cu(i), 0.2e-6, 0.2e-6, .4e-15, 0);
    buffy(i) = c.disp_Emean;
    
end

buffy
disp('finished')
toc
