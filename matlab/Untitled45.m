tic
samples = 1e5;
buffx = zeros(1,samples);
parfor i = 1:length(buffx)  
    a = DAC(8, 1e-14);
    buffx(i) = a.eval(2^7);
end

std = sqrt(var(buffx))
toc