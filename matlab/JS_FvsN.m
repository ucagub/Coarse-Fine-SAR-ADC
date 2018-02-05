%F will be normalized to kT/Ctot for switching scheme comparison

N = 8;
i = N - 1;
s = -1:1:i-1;
cycle = s + 2;
f = [];

c = [1 0 0 0 0 0 0 0;
    1 2 0 0 0 0 0 0;
    1 4 2 0 0 0 0 0;
    1 8 4 2 0 0 0 0;
    1 16 8 4 2 0 0 0;
    1 32 16 8 4 2 0 0;
    1 64 32 16 8 4 2 0;
    1 128 64 32 16 8 4 2];
n = 0;
m = 0;
f = [];
for m = cycle
    x = 0;
    m 
    for n = 1:1:m
        n
        x = x + (2^N/(2^m - c(m,n)))
        
    end
    f = [f,x]
end

N = 1:1:N;
plot(N,f,'-s')
xlabel('Cycle')
ylabel('Fnp,cap')
