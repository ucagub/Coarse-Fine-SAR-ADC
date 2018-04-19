k=1;
tic
samp = 10;
buff_enob = zeros(1,samp);
for i = 1:samp
    a = ADC(10,k, k, 'CS_DAC',34e-15,'CS_DAC',14e-15, 0, 0, .4e-15, 0);
    buff_enob(i) = a.ENOB;
end
buff_enob
toc