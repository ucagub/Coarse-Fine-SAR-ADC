N = 7;
iter = 1e2;
DNL = zeros(iter,2^N-1);
%max = 0;
for i = 1:iter
    a = JS_DAC(N);
    %DNL((i-1)*255+1:i*255) = a.DNL;
    DNL(i,:) = a.DNL;
%     if a.DNL_stdev > max
%         max = a.DNL_stdev;
%     end
end
code_var = zeros(1,2^N-1);
for i = 1:2^N-1
    code_var(i) = var(DNL(:,i));
end

plot(code_var)
max(code_var)