
res = 10;
fine_dac_type = 'CS_DAC';
coarse_dac_type = 'CS_DAC';

samples = 100;
time_elapsed = 0;
% fine_Cu = e-15;sim
k=6
tic
buffy = zeros([1 samples]);
Emean = [0];
parfor i = 1:samples
    c = ADC(res, k, k, 'CS_DAC', 56e-15, 'CS_DAC', 20e-15, 0.2e-6, 0.2e-6, .4e-15, 0);
    buffy(i) = c.disp_ENOB;

end


%cauchy fit part
%a is the histogram mode ENOB
[a, b] = fit_cauchy(buffy);

a
c = ADC(res, k, k, 'CS_DAC', 56e-15, 'CS_DAC', 20e-15, 0.2e-6, 0.2e-6, .4e-15, 0);
% c.disp_ENOB
c.disp_Emean
disp('finished')
toc
