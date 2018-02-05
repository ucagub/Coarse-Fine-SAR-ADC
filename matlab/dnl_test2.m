samples = 100;
dacs = [];
mismatch = 0.05;
n = 6;
for k = 1:samples
    dacs = [dacs multistep_CS_6bit('test', mismatch)];
    k
end

dnls = [];
inls = zeros(samples,2^n-1);
for k = 1:samples
    dnls = [dnls; dacs(k).DNL];
    for u = 1:2^n-1
        for v = 1:u
            inls(k,u) = inls(k,u) + dnls(k,v);
        end
    end
end


DNL_var = [];
INL_var = [];
DNL_mean = [];
for i = 1:2^n-1
    DNL_var = [DNL_var std(dnls(:,i))];
    INL_var = [INL_var std(inls(:,i))];
    DNL_mean = [DNL_mean mean(dnls(:,i))];
end

plot(DNL_var);