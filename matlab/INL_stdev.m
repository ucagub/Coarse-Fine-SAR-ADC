tic
n_points = 10;
mismats = linspace(0.0025, .05, n_points);
N = 10;
iter = 1e3;
INL = zeros(iter,2^N-1);
buff_INL = zeros(1,n_points); 
%max = 0;
tic
for j = 1:length(mismats)
    buffm = mismats(j);
    parfor i = 1:iter
        a = TSCS_DAC(N, (0.008*sqrt(1e-15)/buffm)^2);
        %DNL((i-1)*255+1:i*255) = a.DNL;
        INL(i,:) = a.INL;
    %     if a.DNL_stdev > max
    %         max = a.DNL_stdev;
    %     end
    end
    code_stdv = zeros(1,2^N-1);
    for i = 1:2^N-1
        code_stdv(i) = sqrt(var(INL(:,i)));
    end
    toc

    % stem(code_stdv)
    buff_INL(j) = max(code_stdv);
end
%house keeping
%figure;
p = polyfit(mismats, buff_INL, 1)
hold on
plot(mismats, buff_INL)
xlabel('mismatch');
ylabel('max INL (LSB)');
title('10 bit DAC')
toc