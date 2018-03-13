N = 10;
buff_pow = zeros(1,2^10-1);
buff_mean = zeros(1,9);
tic
for k = 1:9
    parfor i = 1:2^10-1
        buff_pow(i) = multistep_CS_power_10bit_ds(i/2^N, k);
    end
    buff_mean(k) = mean(buff_pow);
end
toc
stem(buff_mean)
xlabel('k - bits');
ylabel('energy/Cu (J/F)')
