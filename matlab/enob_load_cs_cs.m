
res = 10;
fine_dac_type = 'CS_DAC';
coarse_dac_type = 'CS_DAC';
tic
samples = 1e2;
sam_p = 20;

% coarse_noise = (.3712e-03)^2;
% fine_noise = (.1504e-3)^2;
coarse_noise = 0;
fine_noise = 0;

%buffs for cauchy fit
% c_load = linspace(10e-6, 3e-3, sam_p);
c_load = linspace(2e-16, 6e-15, sam_p);
% droop = linspace(10e-6, 3e-3, sam_p);
% droop = 0;
buff_a = zeros(1, sam_p);
% buff_b = zeros(1, sam_p);
time_elapsed = 0;
for j = 1:sam_p
        buf_droop = 0;
    %     buf_c_load = c_load(j);
        buf_c_load = c_load(j);
        tic
        buffy = zeros([1 samples]);
    %     buffx = rand(1,samples)*right_edge + left_edge;
        parfor i = 1:samples
            a = ADC(res, 3, 3, coarse_dac_type, 38e-15, fine_dac_type, 2e-15, coarse_noise, fine_noise, buf_c_load, buf_droop);
            buffy(i) = a.ENOB;
        end

        %cauchy fit part
        %a is the histogram mode ENOB
        [a, b] = fit_cauchy(buffy);
        buff_a(j) = a;
        toc
        time_elapsed = toc + time_elapsed

end
plot(c_load./1e-15, buff_a)
% plot(c_load, buff_a)
toc
