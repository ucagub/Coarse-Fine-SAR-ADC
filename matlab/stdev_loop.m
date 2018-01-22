iter = 1000;
buff = zeros(iter, 255);

for i = 1:iter
    a = Conv_DAC('asfd');
    buff(i,:) = a.DNL;
end

code_var = zeros(1,255);
for i = 1:255
    code_var(i) = var(buff(:,i));
end
code_stdev = sqrt(code_var);
plot(code_stdev)