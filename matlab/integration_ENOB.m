
res = 10;
k = 7;
dac_k = 7;
fine_dac_type = 'TSCS_DAC';
fine_mismatch = 0.008;
coarse_dac_type = 'TSCS_DAC';
coarse_mismatch = 0.008;
tic
samples = 1e2;
sam_p = 4;
left_edge = 0.002;
right_edge = 0.012;
buff_curve = zeros(sam_p,sam_p);

buff_coarse_mismatch = linspace(left_edge, right_edge, sam_p);
buff_fine_mismatch = linspace(left_edge, right_edge, sam_p);
% coarse_noise = (.3712e-03)^2;
% fine_noise = (.1504e-3)^2;
coarse_noise = 0;
fine_noise = 0;

%buffs for cauchy fit

% c_load = linspace(10e-6, 3e-3, sam_p);
c_load = 0;
% droop = linspace(10e-6, 3e-3, sam_p);
droop = 0;
buff_a = zeros(1, sam_p);
% buff_b = zeros(1, sam_p);
time_elapsed = 0;
estimated_time = 8.2*sam_p^2;
for j = 1:sam_p
    for z = 1:sam_p
        estimated_time_left = estimated_time - time_elapsed;
        print_time(estimated_time_left);
        
        coarse_mismatch = buff_coarse_mismatch(j);
        fine_mismatch = buff_fine_mismatch(z);
        buf_droop = droop;
    %     buf_c_load = c_load(j);
        buf_c_load = c_load;
        tic
    %     k
        %buffx = zeros([1 samples], 'gpuArray');
        buffy = zeros([1 samples]);
    %     buffx = rand(1,samples)*right_edge + left_edge;
        parfor i = 1:samples

            %coarse_mismatch = buffx(i);
            a = ADC(res, k, dac_k, coarse_dac_type, (0.008*sqrt(1e-15)/coarse_mismatch)^2, fine_dac_type, (0.008*sqrt(1e-15)/fine_mismatch)^2, coarse_noise, fine_noise, buf_c_load, buf_droop);
            buffy(i) = a.ENOB;
            
        end
        find(buffy>=10)
        %cauchy fit part
        [a, b] = fit_cauchy(buffy);
        %coarse j, fine z
        buff_curve(j,z) = a;
    %     buff_b(j) = b;
        toc
        time_elapsed = toc;
        
    end
end
% plot(droop, buff_a)
% plot(c_load, buff_a)

[X, Y] = meshgrid(buff_coarse_mismatch,buff_fine_mismatch);
surf(X,Y,buff_curve)

ylabel('coarse mismatch')
xlabel('fine mismatch')
zlabel('ENOB')

toc