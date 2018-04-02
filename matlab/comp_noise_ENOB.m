tic
iter = 2e2;
Start = -6.4;
End = -10;
noise = rand(1,iter)*(End - Start) + Start;
buff_noise = 10.^noise;
buff_ENOB = zeros(1,iter);
N = 8;
k = 5;
for k = 4:4
    tic
    k
    figure('Name', [num2str(N) 'bit k=' num2str(k)],'NumberTitle','off')
    parfor i = 1:iter
        a = ADC(N, k, k,'CS_DAC', 1e5, 'CS_DAC', 1e5, buff_noise(i), 0);
        buff_ENOB(i) = a.ENOB;
    end

    scatter(buff_noise, buff_ENOB, 64);
    set(gca,'xscale','log')
    hold on


    buff_ENOB = zeros(1,iter);
    parfor i = 1:iter
        a = ADC(N, k, k,'CS_DAC', 1e5, 'CS_DAC', 1e5, 0, buff_noise(i));
        buff_ENOB(i) = a.ENOB;
    end

    scatter(buff_noise, buff_ENOB, 64, [1 0 0]);
    set(gca,'xscale','log')

    %ideal
    buffx = 10.^(linspace(End,Start,iter));
    buff_ideal = zeros(1,iter);
    %fine
    parfor i = 1:iter
        buff_ideal(i) = ideal_ENOB(sqrt([buffx(i) 0]), k, N);
    end


    buff_ideal2 = zeros(1,iter);
    %coarse
    parfor i = 1:iter
        buff_ideal2(i) = ideal_ENOB(sqrt([0 buffx(i)]), k, N);
    end

    semilogx(buffx, buff_ideal, buffx, buff_ideal2)
    set(gca,'fontsize',30)
    xlabel('noise variance','FontSize', 30)
    ylabel('ENOB','FontSize', 30)
    title(['ENOB vs comparator input referred noise at k=' num2str(k)],'FontSize', 30)
    legend('simulated ENOB', 'simulated ENOB', 'theoretical ENOB', 'theoretical ENOB')
    
    hold off
    toc
end
toc