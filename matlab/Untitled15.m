%start at k = 3;
buff_coarse_tsjs = zeros(1,7);

%buff_co

a = TSJS_DAC(10, 1);
for N = 3:9
    a = TSJS_DAC(N, 1);
    buff_coarse_tsjs(N-2) = a.Emean;
end



buffer = buff_mean(3:end);
figure;
stem([3:9], buffer + buff_coarse_tsjs)
xlabel('k - bits');
ylabel('Average energy/Cu (J/F)')
title('TSJS-TSCS')

bugok = buffer + buff_coarse_tsjs;
for i = 3:9
    text(i, bugok(i-2), num2str(bugok(i-2)), 'FontSize', 20)
end
