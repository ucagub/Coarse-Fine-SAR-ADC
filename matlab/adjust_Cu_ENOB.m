
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
buff_coarse_Cu = [ 109.71 82.34 48.04 25.737 13.298 6.77 3.41 1.71 1]*1e-15;
% coarse_noise = (.3712e-03)^2;
% fine_noise = (.1504e-3)^2;
coarse_noise = 0;
fine_noise = 0;

%buffs for cauchy fit

% c_load = linspace(10e-6, 3e-3, sam_p);
c_load = 0.4e-15;
droop = linspace(10e-6, 3e-3, sam_p);
% droop = 0;
buff_a = zeros(1, 9);
% buff_b = zeros(1, sam_p);
time_elapsed = 0;
for j = 1:9
    dac_k = j;
    k = j
    
%     for z = 1:sam_p
        
%         coarse_mismatch = buff_coarse_mismatch(j);
%         fine_mismatch = buff_fine_mismatch(z);
%         buf_droop = droop(j);
        coarse_Cu = buff_coarse_Cu(j);
        buf_droop = 0;
    %     buf_c_load = c_load(j);
        buf_c_load = c_load;
        tic
    %     k
        %buffx = zeros([1 samples], 'gpuArray');
        buffy = zeros([1 samples]);
    %     buffx = rand(1,samples)*right_edge + left_edge;
        parfor i = 1:samples

            %coarse_mismatch = buffx(i);
%             a = ADC(res, k, dac_k, coarse_dac_type, (0.008*sqrt(1e-15)/coarse_mismatch)^2, fine_dac_type, (0.008*sqrt(1e-15)/fine_mismatch)^2, coarse_noise, fine_noise, buf_c_load, buf_droop);
            a = ADC(res, k, dac_k, coarse_dac_type, coarse_Cu, fine_dac_type, (0.008*sqrt(1e-15)/fine_mismatch)^2, coarse_noise, fine_noise, buf_c_load, buf_droop);
            
            buffy(i) = a.ENOB;
        end

        %cauchy fit part
        [a, b] = fit_cauchy(buffy);
        %coarse j, fine z
        
%         buff_curve(j,z) = a;
        buff_a(j) = a;
    %     buff_b(j) = b;
        toc
        time_elapsed = toc + time_elapsed
%     end
end
stem([1:9], buff_a)
% plot(c_load, buff_a)
toc
