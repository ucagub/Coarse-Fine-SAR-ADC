iter = 5e1;
res = 10;
k = 6;
fine_dac_type = 'TSCS_DAC';
fine_mismatch = 0.04;
coarse_dac_type = 'TSCS_DAC';
coarse_mismatch = 0.04;
coarse_comp_noise = 1e-6;
fine_comp_noise = 1e-6;
tic
low_edge = 1e-6;
high_edge = 1e-5
buffx = rand([1 iter])*(high_edge - low_edge) + low_edge;
buffy = zeros(1,iter);
parfor j = 1:iter
    adc = ADC(res, k, coarse_dac_type, coarse_mismatch, fine_dac_type, fine_mismatch, coarse_comp_noise, buffx(j));
    buffy(j) = adc.ENOB;
end
figure;

hold on
scatter(buffx, buffy, 10);
x = gpuArray.linspace(high_edge, low_edge, length(buffx));
% %     p1 = polyfit(buffx', buffy', 1);
% %     plot(x, polyval(p1,x))
% %     p2 = polyfit(buffx', buffy', 2);
% %     plot(x, polyval(p2,x))
p3 = polyfit(buffx', buffy', 3);
plot(x, polyval(p3,x),'LineWidth',4)
xlabel('fine_comparator_noise');
ylabel('ENOB');
%scatter([1:length(buff)], buff)
%edges = [7:0.025:8];
%histogram(buffy, 'Normalization', 'pdf', 'BinEdges', edges)
hold off
toc
