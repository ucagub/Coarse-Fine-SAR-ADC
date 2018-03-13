samples = 10;%1e3;
res = 10;
k = 7;

fine_dac_type = 'TSCS_DAC';
fine_mismatch = 0.014;
coarse_dac_type = 'TSJS_DAC';
coarse_mismatch = 0.014;
tic
left_edge = 0.001;
right_edge = 0.01;
% coarse_noise = (.3712e-03)^2;
% fine_noise = (.1504e-3)^2;
coarse_noise = 0;
fine_noise = 0;

%buffs for cauchy fit
% buff_a = zeros(1, 7);
% buff_b = zeros(1, 7);
for j = 1:length(buff_a)
    dac_k = j+2;
    tic
    k
    %buffx = zeros([1 samples], 'gpuArray');
    buffy = zeros([1 samples]);
%     buffx = rand(1,samples)*right_edge + left_edge;
    parfor i = 1:samples
        
        %coarse_mismatch = buffx(i);
        a = ADC(res, k, dac_k, coarse_dac_type, (0.008*sqrt(1e-15)/coarse_mismatch)^2, fine_dac_type, (0.008*sqrt(1e-15)/fine_mismatch)^2, coarse_noise, fine_noise);
        buffy(i) = a.ENOB;
    end
    
    %house keeping
%     figure('Name', ['k=' num2str(k) ' N=' num2str(res) ' ' 'mismatch vs ENOB' ' ' coarse_dac_type ' ' fine_dac_type], 'NumberTitle','off');
%     ax1 = subplot(1,3,1);
%     xlabel(ax1,'mismatch');
%     ylabel(ax1,'ENOB');
%     scatter(buffx, buffy, 10);
%     hold on
%     % parfor j = 1:3
%     x = linspace(left_edge, right_edge, length(buffx));
%     %     p1 = polyfit(buffx', buffy', 1);
%     %     plot(x, polyval(p1,x))
%     %     p2 = polyfit(buffx', buffy', 2);
%     %     plot(x, polyval(p2,x))
%     p3 = polyfit(buffx', buffy', 3);
%     plot(x, polyval(p3,x),'LineWidth',2)
%     hold off
%       
%     %figure;
%     
%     dat = [buffx' buffy'];
%     ax2 = subplot(1,3,2);
%     xlabel(ax2,'mismatch');
%     ylabel(ax2,'ENOB');
%     hist3(dat)
%     title('ENOB vs mismatch')
%     xlabel('ENOB'); ylabel('mismatch');
%     set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
%     %figure;
%     ax3 = subplot(1,3,3);
%     title(ax3, 'Data Point Density Histogram and Intensity Map')
%     xlabel(ax3,'mismatch');
%     ylabel(ax3,'ENOB');
%     n = hist3(dat);
%     n1 = n';
%     n1(size(n,1) + 1, size(n,2) + 1) = 0;
%     xb = linspace(min(dat(:,1)),max(dat(:,1)),size(n,1)+1);
%     yb = linspace(min(dat(:,2)),max(dat(:,2)),size(n,1)+1);
%     h = pcolor(xb,yb,n1);
%     h.ZData = ones(size(n1)) * -max(max(n));
% 
%     colormap(hot) % heat map
%     
%     grid on
%     view(2);
%     xlabel('mismatch'); ylabel('ENOB');
%     %savefig(['hist3d/ENOBvsFineMismatch_' num2str(res) 'bit_TSCS_k=' num2str(k) '.fig']);  

%cauchy fit part
%     [a, b] = fit_cauchy(buffy);
%     buff_a(j) = a;
%     buff_b(j) = b;

    toc
end
toc
% 
% plot([3:9], buff_a);