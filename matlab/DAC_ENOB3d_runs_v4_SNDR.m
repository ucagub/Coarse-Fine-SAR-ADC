
res = 10;
k = 7;
dac_k = 7;
fine_dac_type = 'CS_DAC';

coarse_dac_type = 'CS_DAC';

tic
samples = 1e2;
sam_p = 10;

buff_curve = zeros(sam_p,sam_p);

coarse_Cu = linspace(10e-15, 70e-15, sam_p);
fine_Cu = linspace(10e-15, 22e-15, sam_p);
coarse_noise = 0.2e-6;
fine_noise = 0.2e-6;
fine_load_cap = linspace(2.15e-16,1.75e-15, 10) + .29e-15;
surfaces = {};

%buffs for cauchy fit

% c_load = linspace(10e-6, 3e-3, sam_p);
c_load = .4e-15;
% droop = linspace(10e-6, 3e-3, sam_p);
droop = 0;
time_elapsed = 0;
estimated_time = 2.2*sam_p^2*10*10;
print_time(estimated_time);
for surface = 1:length(fine_load_cap)
    buff_fine_load_cap = fine_load_cap(surface);
    for k = 0:9
        buff_a = zeros(1, sam_p);
        % buff_b = zeros(1, sam_p);

        for j = 1:sam_p
            for z = 1:sam_p
                estimated_time_left = estimated_time - time_elapsed;
                print_time(estimated_time_left);
                buff_fine_Cu = fine_Cu(z);
                buff_coarse_Cu = coarse_Cu(j);
                buf_droop = droop;
                
            %     buf_c_load = c_load(j);
                buf_c_load = c_load;
                tic
                surface
                k
                
                buffy = zeros([1 samples]);
                
                parfor i = 1:samples
                    a = ADC(res, k, k, coarse_dac_type, buff_coarse_Cu, fine_dac_type, buff_fine_Cu, .1250e-6, .0286e-6, .5e-15, buff_fine_load_cap, buf_droop);
                    a.disp_ENOB;
                    buffy(i) = a.SNDR;
                end
                %cauchy fit part
                close;
                figure;
                [a, b] = fit_cauchy(buffy);
                a
                buff_curve(j,z) = a;
                toc
                time_elapsed = toc + time_elapsed;
            end
        end
        toc
        surfaces{surface, k+1} = buff_curve;
        buff_curve = zeros(sam_p,sam_p);
    end
end

label = ['cs-cs-3d-200ksps-loaded-with-noise-SNDR/katuparan_ng_pangarap.mat'];
save(label)
label = ['cs-cs-3d-200ksps-loaded-with-noise-SNDR/katuparan_ng_pangarapv2.mat', 'surfaces'];
save(label)
disp('finished madafaka')

