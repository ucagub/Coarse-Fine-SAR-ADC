

iter = 2e2;

ENOB = zeros([1 iter]);
mismatch = zeros([1 iter]);
res = 10;
fine_dac_type = 'TSCS_DAC';
fine_Cu = 1;
coarse_dac_type = 'TSCS_DAC';
coarse_Cu = 1;
constant = sqrt(1e-15)*0.05;

%for k  = 2:7 
    k = 6
    tic
    left_edge = -4;
    right_edge= -7;
%     buff_Cu = rand([1 iter])*(right_edge - left_edge) + left_edge;
    buff_coarse_noise = rand([1 iter])*(right_edge - left_edge) + left_edge;
    buff_coarse_noise = 10.^buff_coarse_noise;
    buff_ENOB = zeros([1 iter]);
    parfor i = 1:iter
        a = ADC(res, k, coarse_dac_type, coarse_Cu, fine_dac_type, fine_Cu, buff_coarse_noise(i), 0);
        buff_ENOB(i) = a.ENOB;
    end
%     figure('Name', ['ENOBvsMismatch_8bit_coarse' coarse_dac_type 'fine_' fine_dac_type 'k=' num2str(k)])
    figure;
    xlabel('comparator noise variance');
    ylabel('ENOB');
    hold on
    scatter(buff_coarse_noise, buff_ENOB, 10, [1 0 0]);
    set(gca,'xscale','log');
%     x = gpuArray.linspace(left_edge, right_edge, length(buff_coarse_noise));
%     x = 10.^x;
% %     p3 = polyfit(mismatch', ENOB', 5);
% %     plot(x, polyval(p3,x),'LineWidth',4, 'Color', 'r')
% %     p2 = polyfit(mismatch', ENOB', 4);
% %     plot(x, polyval(p2,x),'LineWidth',4, 'Color', 'g')
%     p1 = polyfit(buff_coarse_noise', buff_ENOB', 2);
%     plot(x, polyval(p1,x),'LineWidth',1, 'Color', 'r')
%     p = polyfit(mismatch', ENOB', 2);
%     plot(x, polyval(p,x),'LineWidth',4, 'Color', 'y')
    
%     savefig(['ENOB_hist/8bisdt_coarse_fine/ENOBvsMismatch_8bit_CS_CS_k' num2str(k) '_.fig']);   
%     save(['ENOB_hist/8bsdit/ENOBvsMismatch_8bit_V2_CS_CS_k' num2str(k) '.mat'])
    toc
%end

ENOB = zeros([1 iter], 'gpuArray');
mismatch = zeros([1 iter], 'gpuArray');
res = 8;
fine_dac_type = 'TSCS_CS';
fine_Cu = 1;
coarse_dac_type = 'TSCS_DAC';
coarse_Cu = 1;
constant = sqrt(1e-15)*0.05;

%for k  = 2:7 
    k = 6
    tic
    left_edge = -4;
    right_edge= -7;
%     buff_Cu = rand([1 iter])*(right_edge - left_edge) + left_edge;
    buff_coarse_noise = rand([1 iter])*(right_edge - left_edge) + left_edge;
    buff_coarse_noise = 10.^buff_coarse_noise;
    buff_ENOB = zeros([1 iter]);
    parfor i = 1:iter
        a = ADC(res, k, coarse_dac_type, coarse_Cu, fine_dac_type, fine_Cu, 0, buff_coarse_noise(i));
        buff_ENOB(i) = a.ENOB;
    end
    %figure('Name', ['ENOBvsMismatch_8bit_coarse' coarse_dac_type 'fine_' fine_dac_type 'k=' num2str(k)])
    %xlabel('fine comparator noise');
    %ylabel('ENOB');
    %hold on
    scatter(buff_coarse_noise, buff_ENOB, 10);
    set(gca,'xscale','log');
%     x = gpuArray.linspace(left_edge, right_edge, length(buff_coarse_noise));
%     x = 10.^x;
% %     p3 = polyfit(mismatch', ENOB', 5);
% %     plot(x, polyval(p3,x),'LineWidth',4, 'Color', 'r')
% %     p2 = polyfit(mismatch', ENOB', 4);
% %     plot(x, polyval(p2,x),'LineWidth',4, 'Color', 'g')
%     p1 = polyfit(buff_coarse_noise', buff_ENOB', 2);
%     plot(x, polyval(p1,x),'LineWidth',1, 'Color', 'r')
%     p = polyfit(mismatch', ENOB', 2);
%     plot(x, polyval(p,x),'LineWidth',4, 'Color', 'y')
    
%     savefig(['ENOB_hist/8bisdt_coarse_fine/ENOBvsMismatch_8bit_CS_CS_k' num2str(k) '_.fig']);   
%     save(['ENOB_hist/8bsdit/ENOBvsMismatch_8bit_V2_CS_CS_k' num2str(k) '.mat'])
    toc
%end

hold off



