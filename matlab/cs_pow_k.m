%start at k = 3;
buff_coarse_e = zeros(1,7);

%buff_co
j = 1;
buff_pow = zeros(1,2^10-1);
for i = 1:2^10-1
    buff_pow(i) = multistep_CS_power_3bit(i/2^10);
end
buff_coarse_e(j) =  mean(buff_pow);
j = j + 1;

buff_pow = zeros(1,2^10-1);
for i = 1:2^10-1
    buff_pow(i) = multistep_CS_power_4bit(i/2^10);
end
buff_coarse_e(j) =  mean(buff_pow);
j = j + 1;

buff_pow = zeros(1,2^10-1);
for i = 1:2^10-1
    buff_pow(i) = multistep_CS_power_5bit(i/2^10);
end
buff_coarse_e(j) =  mean(buff_pow);
j = j + 1;

buff_pow = zeros(1,2^10-1);
for i = 1:2^10-1
    buff_pow(i) = multistep_CS_power_6bit(i/2^10);
end
buff_coarse_e(j) =  mean(buff_pow);
j = j + 1;

buff_pow = zeros(1,2^10-1);
for i = 1:2^10-1
    buff_pow(i) = multistep_CS_power_7bit(i/2^10);
end
buff_coarse_e(j) =  mean(buff_pow);
j = j + 1;

buff_pow = zeros(1,2^10-1);
for i = 1:2^10-1
    buff_pow(i) = multistep_CS_power_8bit(i/2^10);
end
buff_coarse_e(j) =  mean(buff_pow);
j = j + 1;

buff_pow = zeros(1,2^10-1);
for i = 1:2^10-1
    buff_pow(i) = multistep_CS_power_9bit(i/2^10);
end
buff_coarse_e(j) =  mean(buff_pow);
j = j + 1;

buffer = buff_mean(3:end);
figure;
stem([3:9], buffer + buff_coarse_e)
xlabel('k - bits');
ylabel('Average energy/Cu (J/F)')
title('TSCS-TSCS')
