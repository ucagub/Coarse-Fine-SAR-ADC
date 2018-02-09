
res = 8;
k = 4;

fine_dac_type = 'CS_DAC';
fine_mismatch = 0.05;
coarse_dac_type = 'JS_DAC';
coarse_mismatch = 0.05;
tic
for k = 2:7
    samples = 1e4;
    buffx = zeros([1 samples], 'gpuArray');
    buffy = zeros([1 samples], 'gpuArray');
    
    parfor i = 1:samples
        coarse_mismatch = rand(1)*0.09 + 0.01;
        buffx(i) = coarse_mismatch;
        buffy(i) = one_ENOB(res, k, coarse_dac_type, coarse_mismatch, fine_dac_type, fine_mismatch);
    end

    scatter(buffx, buffy, 10);

    % parfor j = 1:3
    x = gpuArray.linspace(0.01, 0.1, length(buffx));
    %     p1 = polyfit(buffx', buffy', 1);
    %     plot(x, polyval(p1,x))
    %     p2 = polyfit(buffx', buffy', 2);
    %     plot(x, polyval(p2,x))
    p3 = polyfit(buffx', buffy', 5);
    plot(x, polyval(p3,x),'LineWidth',6)
    hold off
    %savefig(['ENOB_hist/8bit_coarse_fine/ENOBvsMismatch_8bit_JS_CS_k' num2str(k) '_.fig']);    
    toc
end
toc

