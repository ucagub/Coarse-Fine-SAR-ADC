samples = 1e2;
res = 10;
k = 7;
dac_k = 7;
fine_dac_type = 'TSCS_DAC';
fine_mismatch = 0.008;
coarse_dac_type = 'TSCS_DAC';
coarse_mismatch = 0.008;
tic
left_edge = 0.001;
right_edge = 0.01;
% coarse_noise = (.3712e-03)^2;
% fine_noise = (.1504e-3)^2;
coarse_noise = 0;
fine_noise = 0;

%buffs for cauchy fit
sam_p = 30;
% c_load = linspace(10e-6, 3e-3, sam_p);
c_load = 3e-15;
droop = linspace(10e-6, 3e-3, sam_p);
% droop = 1e-3;
buff_a = zeros(1, sam_p);
buff_b = zeros(1, sam_p);
for j = 1:sam_p
    buf_droop = droop(j);
%     buf_c_load = c_load(j);
    buf_c_load = c_load;
    tic
    k
    %buffx = zeros([1 samples], 'gpuArray');
    buffy = zeros([1 samples]);
%     buffx = rand(1,samples)*right_edge + left_edge;
    parfor i = 1:samples
        
        %coarse_mismatch = buffx(i);
        a = ADC(res, k, dac_k, coarse_dac_type, (0.008*sqrt(1e-15)/coarse_mismatch)^2, fine_dac_type, (0.008*sqrt(1e-15)/fine_mismatch)^2, coarse_noise, fine_noise, buf_c_load, buf_droop);
        buffy(i) = a.ENOB;
    end
    %histogram(buffy)
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
    
%     grid on
%     view(2);
%     xlabel('mismatch'); ylabel('ENOB');
%     %savefig(['hist3d/ENOBvsFineMismatch_' num2str(res) 'bit_TSCS_k=' num2str(k) '.fig']);  

    %cauchy fit part
    [a, b] = fit_cauchy(buffy);
    buff_a(j) = a;
    buff_b(j) = b;
end
plot(droop, buff_a)
% plot(c_load, buff_a)
toc