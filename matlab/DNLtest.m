samples = 100;
mismatch = 0.05;
xaxis = [];
DNL_max = [];
for mismatch = 0.04:0.0001:0.07
    dacs = [];
    for k = 1:samples
        dacs = [dacs DAC('test', mismatch)];
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

    xaxis = [xaxis mismatch];
    DNL_max = [DNL_max max(DNL_var)];
end
figure;
plot(DNL_var);
xlabel('Output Code');
ylabel('DNL variance');

figure;
plot(INL_var);
xlabel('Output Code');
ylabel('INL variance');