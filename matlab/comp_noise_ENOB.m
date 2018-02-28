tic
iter = 1e2;
Start = -4;
End = -8;
noise = rand(1,iter)*(End - Start) + Start;
buff_noise = 10.^noise;
buff_ENOB = zeros(1,iter);
N = 8;
k = 4;
parfor i = 1:iter
    a = ADC(N, k, 'CS_DAC', 1e5, 'CS_DAC', 1e5, buff_noise(i), 0);
    buff_ENOB(i) = a.ENOB;
end

scatter(buff_noise, buff_ENOB, 4);
set(gca,'xscale','log')
hold on


buff_ENOB = zeros(1,iter);
parfor i = 1:iter
    a = ADC(N, k, 'CS_DAC', 1e5, 'CS_DAC', 1e5, 0, buff_noise(i));
    buff_ENOB(i) = a.ENOB;
end

scatter(buff_noise, buff_ENOB, 4, [1 0 0]);
set(gca,'xscale','log')

buffx = 10.^(linspace(End,Start,iter));
buff_ideal = zeros(1,iter);
parfor i = 1:iter
    buff_ideal(i) = ideal_ENOB(sqrt([0 buffx(i)]), k, N);
end


buff_ideal2 = zeros(1,iter);
parfor i = 1:iter
    buff_ideal2(i) = ideal_ENOB(sqrt([buffx(i) 0]), k, N);
end

semilogx(buffx, buff_ideal, buffx, buff_ideal2)
hold off

toc