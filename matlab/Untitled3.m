tic
N = 10;
buffx = zeros([1 2^N-1]);
buffy = zeros([1 2^N-1]);
parfor i = 1:2^N-1
    buffy(i) = multistep_CS_power_10bit(i);
end

plot(buffx, buffy)
toc