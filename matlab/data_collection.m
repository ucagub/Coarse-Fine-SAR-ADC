samples = 1e4;
buff = -(rand(1,samples)*(7.5-6.4) + 6.4);
coarse_comp_noise = 10.^buff; 
buff = -(rand(1,samples)*(8-7.5) + 7.5);
fine_comp_noise = 10.^buff;
%k_dac = randi([3 9],1,samples);
k_comp = randi([3 9],1,samples);
coarse_dac_mismatch = rand(1,samples)*(0.01-.0025) + 0.0025;
fine_dac_mismatch = coarse_dac_mismatch;
%droop = 1e-3;
droop = 0;
coarse_dac_type = 'TSCS_DAC';
fine_dac_type = 'TSCS_DAC';

res = 10;
sam_p = 1e2

data_label = zeros(samples,5);
data_value = zeros(samples,1);
time_elapsed = 0;
tic
estimated_time = 8.8*samples;
file_index = 1;
for j = 1:samples
    estimated_time_left = estimated_time - time_elapsed;
    print_time(estimated_time_left);
    b_ccn = coarse_comp_noise(j);
    b_fcn = fine_comp_noise(j);
    %b_kd
    b_kc = k_comp(j);
    b_cdm = coarse_dac_mismatch(j);
    b_fdm = fine_dac_mismatch(j);
    
    buffy = zeros([1 samples]);
    %     buffx = rand(1,samples)*right_edge + left_edge;
    parfor i = 1:sam_p

        %coarse_mismatch = buffx(i);
        a = ADC(res, b_kc, b_kc, coarse_dac_type, (0.008*sqrt(1e-15)/b_cdm)^2, fine_dac_type, (0.008*sqrt(1e-15)/b_fdm)^2, b_ccn, b_fcn, 0, droop);
        buffy(i) = a.ENOB;
    end
    
    %cauchy fit part
        [a, b] = fit_cauchy(buffy);
    %save data
        data_label(j,:) = [b_ccn, b_fcn, b_cdm, b_fdm, b_kc];
        data_value(j) = a;
    toc
    time_elapsed = toc;
    
    %save as pkl data
    if mod(j,100) == 0
        buffer_data_label = data_label(100*(file_index-1)+1:100*file_index,:);
        mat2np(buffer_data_label, ['pickles/label' num2str(file_index) '00.pkl'], 'float64');
        buffer_data_value = data_value(100*(file_index-1)+1:100*file_index);
        mat2np(buffer_data_value, ['pickles/value' num2str(file_index) '00.pkl'], 'float64');
        file_index = file_index + 1; 
    end
    

end
save('learn_dat.mat');
disp('finished')