tic
iter = 2e2;
buff = zeros(1,iter);
parfor j = 1:iter
    %dac = DAC(8);
    adc = ADC(8, 'CS_DAC', 0.05);
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
    j
end
buff
histogram(buff, 'Normalization', 'pdf')
%histogram(buff, 10)
toc
