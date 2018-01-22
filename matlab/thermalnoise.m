%thermal noise for conventional

for N = 1:16
    F(N) = 1/(2^N - 1);
        for m = 0:N-1
            F(N) = F(N) + 1/(2^(N-m) - 1);
        end
    V2n(N) = F(N)*(1/2^N);
end

stem(1:16,F)
figure;
stem(1:16,V2n)
            
