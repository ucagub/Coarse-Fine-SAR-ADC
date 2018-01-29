
power = [];
powerCS = [];
for i = 0:255
    power = [power multistep_CS_power(i/256)];
    %powerCS = [powerCS CS_power(i)];
end

plot(power);
% hold on;
% plot(powerCS);