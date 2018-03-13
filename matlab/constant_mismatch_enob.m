samples = 1e3;
res = 10;
k = 7;

fine_dac_type = 'TSCS_DAC';
fine_mismatch = 0.02;
coarse_dac_type = 'TSCS_DAC';
coarse_mismatch = 0.02;
tic
% left_edge = 0.001;
% right_edge = 0.01;
% coarse_noise = (.3712e-03)^2;
% fine_noise = (.1504e-3)^2;
coarse_noise = 0;
fine_noise = 0;
for dac_k = 3:3
    tic
    k
    %buffx = zeros([1 samples], 'gpuArray');
    buffy = zeros([1 samples]);
    %buffx = rand(1,samples)*right_edge + left_edge;
    parfor i = 1:samples
        
        %coarse_mismatch = buffx(i);
        a = ADC(res, k, dac_k, coarse_dac_type, (0.008*sqrt(1e-15)/coarse_mismatch)^2, fine_dac_type, (0.008*sqrt(1e-15)/fine_mismatch)^2, coarse_noise, fine_noise);
        buffy(i) = a.ENOB;
    end
    
    %house keeping
    figure('Name', ['k=' num2str(k) ' N=' num2str(res) ' ' 'mismatch vs ENOB' ' ' coarse_dac_type ' ' fine_dac_type], 'NumberTitle','off');
    histogram(buffy, 40)
    xlabel('ENOB');
    %savefig(['hist3d/ENOBvsFineMismatch_' num2str(res) 'bit_TSCS_k=' num2str(k) '.fig']);  
    toc
end
toc

