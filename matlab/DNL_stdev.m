iter = 1e3;
DNL = zeros(iter,255);
%max = 0;
for i = 1:iter
    a = DAC(1);
    %DNL((i-1)*255+1:i*255) = a.DNL;
    DNL(i,:) = a.DNL;
%     if a.DNL_stdev > max
%         max = a.DNL_stdev;
%     end
end
code_var = zeros(1,255);
for i = 1:255
    code_var(i) = var(DNL(:,i));
end

plot(code_var)
max(code_var)