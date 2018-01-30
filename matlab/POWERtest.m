
power = [];
powerCS = [];
for i = 0:255
    power = [power multistep_CS_power(i/256)];
    %powerCS = [powerCS CS_power(i)];
end

average = mean(power).*ones(1,256);
plot(power);
hold on;
plot(average);
xlabel('Output Code');
% hold on;
% plot(powerCS);