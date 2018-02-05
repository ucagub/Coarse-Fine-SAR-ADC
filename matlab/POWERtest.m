
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
legend('Conv','Avg. Conv','CapSplit','Avg. CapSplit','J-S','Avg. J-S','2-step JS','Avg 2-step JS','multi-step CS','Avg multi-step CS');
%xlabel('Output Code');
% hold on;
% plot(powerCS);