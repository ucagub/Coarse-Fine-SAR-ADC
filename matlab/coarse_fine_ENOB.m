
ENOB = [];
mismatch = [];
iter = 1e2;
res = 8;
k = 4;
%for k = 2:7
    fine_dac_type = 'CS_DAC';
    fine_mismatch = 0.05;
    coarse_dac_type = 'CS_DAC';
    coarse_mismatch = 0.05;
    %j=0;
    %fine sample points from 0.01 t0 0.1
    for j  = 0.01:0.01:0.1 
        coarse_mismatch = j
        tic
        ENOB = [ENOB get_ENOB(iter, res, k, coarse_dac_type, coarse_mismatch, fine_dac_type, fine_mismatch)];
        mismatch = [mismatch j];
        toc
    end
    %coarse sample points from 0.15 t0 0.5
    for i  = 0.15:0.05:0.5 
        coarse_mismatch = i
        tic
        ENOB = [ENOB get_ENOB(iter, res, k, coarse_dac_type, coarse_mismatch, fine_dac_type, fine_mismatch)];
        mismatch = [mismatch i];
        toc
    end
    figure('Name', ['ENOBvsMismatch_8bit_coarse' coarse_dac_type 'fine_' fine_dac_type 'k=' num2str(k)])
    plot(mismatch, ENOB)
    xlabel('mismatch');
    ylabel('ENOB');
    savefig(['ENOB_hist/8bit_coarse_fine_CS_CS/ENOBvsMismatch_8bit_CS_CS_k' num2str(k) '_.fig']);
%end
