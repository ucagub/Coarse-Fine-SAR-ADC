

iter = 1e5;

ENOB = zeros([1 iter], 'gpuArray');
mismatch = zeros([1 iter], 'gpuArray');
res = 8;
fine_dac_type = 'CS_DAC';
fine_mismatch = 0.05;
coarse_dac_type = 'CS_DAC';
coarse_mismatch = 0.05;

for k  = 2:7 
    k
    tic
    [mismatch(:), ENOB(:)] = get_ENOBs(iter, res, k, coarse_dac_type, coarse_mismatch, fine_dac_type, fine_mismatch);

    figure('Name', ['ENOBvsMismatch_8bit_coarse' coarse_dac_type 'fine_' fine_dac_type 'k=' num2str(k)])
    xlabel('mismatch');
    ylabel('ENOB');
    hold on
    scatter(mismatch, ENOB, 10);
    x = gpuArray.linspace(0.005, 0.2, length(mismatch));
    p3 = polyfit(mismatch', ENOB', 5);
    plot(x, polyval(p3,x),'LineWidth',6)
    
    savefig(['ENOB_hist/8bit_coarse_fine/ENOBvsMismatch_8bit_CS_CS_k' num2str(k) '_.fig']);    
    toc
end

hold off



%iter = 1e1
ENOB = zeros([1 iter], 'gpuArray');
mismatch = zeros([1 iter], 'gpuArray');
res = 8;
fine_dac_type = 'CS_DAC';
fine_mismatch = 0.05;
coarse_dac_type = 'JS_DAC';
coarse_mismatch = 0.05;

for k  = 2:7 
    k
    tic
    [mismatch(:), ENOB(:)] = get_ENOBs(iter, res, k, coarse_dac_type, coarse_mismatch, fine_dac_type, fine_mismatch);

    figure('Name', ['ENOBvsMismatch_8bit_coarse' coarse_dac_type 'fine_' fine_dac_type 'k=' num2str(k)])
    xlabel('mismatch');
    ylabel('ENOB');
    hold on
    scatter(mismatch, ENOB, 10);
    x = gpuArray.linspace(0.005, 0.2, length(mismatch));
    p3 = polyfit(mismatch', ENOB', 5);
    plot(x, polyval(p3,x),'LineWidth',6)
    
    savefig(['ENOB_hist/8bit_coarse_fine/ENOBvsMismatch_8bit_V2_JS_CS_k' num2str(k) '_.fig']);    
    toc
end


