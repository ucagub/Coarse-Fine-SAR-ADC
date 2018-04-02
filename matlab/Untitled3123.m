N = 10;
LSB = 1/2^N;
a = LSB^2/12;
b = 7;
mse = 0.1455;
buff = mse*LSB^2 + LSB^2/12 - 2*a*(1-exp(-b*mse));
ENOB = (10*log10( ( LSB*2^N/(2*sqrt(2)) )^2/buff ) - 1.76)/6.02