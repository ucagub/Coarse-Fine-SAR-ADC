function y = DNL(DAC)
    
    Vref = 1;
    res = 4;
    DNL = [0];
    INL = [0];
    LSB = vpa((DAC(2^res-1) - DAC(0))/(2^res-1));
    %power = (1*(DAC(2^res-1) - DAC(0))/(2^res-1))^2;
    %error = normrnd(0,sqrt(power),[1,2^res-1]);
    %LSB = 1/2^res
    %LSB = 0.0625
    for i = 1:(2^res-1)
        buff = DAC(i) - DAC(i-1) - LSB ;
        DNL = [DNL buff];
        INL = [INL sum(DNL)];
    end
    
    offsetError= DAC(0)
    gainError = 100*((DAC(2^res-1)-DAC(0))/(Vref-Vref/2^res) - 1);
    figure('name','DNL INL','NumberTitle','off');
    
    subplot(2,1,1)       % add first plot in 2 x 1 grid
    stem(DNL/(LSB));
    title('DNL')

    subplot(2,1,2)       % add second plot in 2 x 1 grid
    stem(INL/(LSB));       % plot using + markers
    title('INL')
    
    %stem(DNL);
    %y = DAC(1);
end
