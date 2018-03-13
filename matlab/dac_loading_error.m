
N = 10;
Cu = 10e-15;
LSB = 1/2^N;
load = 1e-15;
cs_error = ((2^N-1)/2^N  - Cu*(2^N-1)/(Cu*2^N + load))/LSB


tscs_error = (1/2^(N/2))*(Cu/(2*Cu + load))/LSB