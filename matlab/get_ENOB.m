function output = get_ENOB(iter, res, dac_type, mismatch)
    %inputs: iter number of simulations
    %      : res bit resolution, dac_typem, mismatch in dac for adc to be characterized    
    %return: the mostlikely ENOB

    buff = zeros(1,iter);
    parfor j = 1:iter
        %dac = DAC(8);
        adc = ADC(res, dac_type, mismatch);
        fs = 3.15e4;
        f0 = 5e2;
        N = 1024*2;
        t = (0:N-1)/fs;

        y = 0.5*sin(2*pi*f0*t) + 0.5;
        z = zeros(1, length(y));
        for i = 1:length(y)
            z(i) = adc.quantizer(y(i));
        end
        %sinad(z,fs)
        b = sinad(z,fs);
        ENOB = (b-1.76)/6.02;
        buff(j) = ENOB;
    end
    h = histogram(buff, 'Normalization', 'pdf')
    left_edge = find(h.Values == max(h.Values));
    output = mean(h.BinEdges(left_edge:left_edge+1));
end