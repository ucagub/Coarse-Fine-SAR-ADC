function ENOB = ideal_ENOB(u, k, N, varargin)
    %([fine_comp_noise coarse_comp_noise], k=coarse stage bits, resolution, Vref)
    %stdev
    if nargin == 4
        Vref = varargin{1};
    else
        Vref = 1;
    end
    
    LSB = Vref/2^N;
    a = LSB^2/12;
    b = 7;
    mse = MSE(u, k, N);
    %mse = 0;
    buff = mse*LSB^2 + LSB^2/12 - 2*a*(1-exp(-b*mse));
    ENOB = (10*log10( ( LSB*2^N/(2*sqrt(2)) )^2/buff ) - 1.76)/6.02;
end