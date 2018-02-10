mu = 0;
stdev = 1e-2;
actual_sigma = stdev^2
Vin = [-1:1e-4:1];
iter = 1e4;
parfor i = 1:length(Vin)
    buff = Vin(i) + normrnd(mu, stdev, [1 iter]);
    buffy(i) = length( find(buff>0) )/length( buff );
end

stdev_point = cdf('Normal',-1,0,1);
[d, ix] = min(abs(buffy-stdev_point));
actual = buffy(ix);

measured_sigma = Vin(ix)^2
