samples = 1000;
mismatch = 0.05;

dacs = [];
for k = 1:samples
    dacs = [dacs multistep_CS('test', mismatch)];
    k
end

dnls = [];
inls = zeros(samples,255);
for k = 1:samples
    dnls = [dnls; dacs(k).DNL];
    for u = 1:255
        for v = 1:u
            inls(k,u) = inls(k,u) + dnls(k,v);
        end
    end
end


DNL_var = [];
INL_var = [];
DNL_mean = [];
for i = 1:255
    DNL_var = [DNL_var var(dnls(:,i))];
    INL_var = [INL_var var(inls(:,i))];
    DNL_mean = [DNL_mean mean(dnls(:,i))];
end

figure;
plot(DNL_var);
xlabel('Output Code');
ylabel('DNL variance');

figure;
plot(INL_var);
xlabel('Output Code');
ylabel('INL variance');