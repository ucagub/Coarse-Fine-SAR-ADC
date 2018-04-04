


tic
samples = 1e2;
parfor i = 1:samples

    %coarse_mismatch = buffx(i);
%             a = ADC(res, k, dac_k, coarse_dac_type, (0.008*sqrt(1e-15)/coarse_mismatch)^2, fine_dac_type, (0.008*sqrt(1e-15)/fine_mismatch)^2, coarse_noise, fine_noise, buf_c_load, buf_droop);
    a = ADC(10,'CS_DAC', 1e-15, .4e-15)

    buffy(i) = a.ENOB;
end

%cauchy fit part
[a, b] = fit_cauchy(buffy)
%coarse j, fine z
toc


