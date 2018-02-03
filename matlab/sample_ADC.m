function y = sample_ADC(dac, Vin)
    N = dac.res;
    Vref = 1;
    Vup = 2^N;
    Vdown = 0;
    buff_out = zeros(1,N);
    for i = 1:N
        if Vin > dac.eval((Vup+Vdown)/2)
            Vdown = (Vup+Vdown)/2;
            buff_out(i) = 1;
        else
            Vup = (Vup+Vdown)/2;
            buff_out(i) = 0;
        end 
    end
    y = Vref*bi2de(buff_out, 'left-msb')/(2^N);
end