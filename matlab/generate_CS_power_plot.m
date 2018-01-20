energy = []
for i = 0:255
    energy = [energy CS_power(i)];
end
plot(energy)