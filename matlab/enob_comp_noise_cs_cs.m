
res = 10;
fine_dac_type = 'CS_DAC';
coarse_dac_type = 'CS_DAC';
tic
samples = 1e2;
sam_p = 20;

% coarse_noise = (.3712e-03)^2;
% fine_noise = (.1504e-3)^2;


coarse_noise = linspace(1.25e-07, 1.06e-08, sam_p);;
fine_noise = 0;

%buffs for cauchy fit
% c_load = linspace(10e-6, 3e-3, sam_p);
c_load = linspace(2e-16, 6e-15, sam_p);
% droop = linspace(10e-6, 3e-3, sam_p);
% droop = 0;
buff_a = zeros(1, sam_p);
% buff_b = zeros(1, sam_p);
time_elapsed = 0;
fine_Cu = 1e-15;
buff_fine_Cus = [1 2 10]*1e-15;
for m = 1:length(buff_fine_Cus)
    %set fine Cu
    fine_Cu = buff_fine_Cus(m);
    for j = 1:sam_p
            buf_droop = 0;
        %     buf_c_load = c_load(j);
            buf_c_load = c_load(j);
            buf_f_load = c_load(j);
            tic
            buffy = zeros([1 samples]);
        %     buffx = rand(1,samples)*right_edge + left_edge;
            parfor i = 1:samples
    %             a = ADC(res, 3, 3, coarse_dac_type, 38e-15, fine_dac_type, 2e-15, coarse_noise, fine_noise, buf_c_load, buf_f_load, buf_droop);
                a = ADC(res, 3, 3, coarse_dac_type, 38e-15, fine_dac_type, fine_Cu, coarse_noise, fine_noise, buf_c_load, buf_droop);
                buffy(i) = a.ENOB;
            end

            %cauchy fit part
            %a is the histogram mode ENOB
            [a, b] = fit_cauchy(buffy);
            buff_a(j) = a;
            toc
            time_elapsed = toc + time_elapsed

    end
end
figure;
plot(c_load./1e-15, buff_a,'LineWidth',8)
set(gca, 'FontSize', 30)
xlabel('load cap (fF)', 'FontSize', 30)
ylabel('ENOB', 'FontSize', 30)
label = ['ENOB vs load cap fine-Cu =' num2str(fine_Cu/1e-15) ' fF'];
title(label, 'FontSize', 30)

% plot(c_load, buff_a)
toc
