%F will be normalized to kT/Ctot for switching scheme comparison
k = 1.3087 * 10^-23;    %Boltzmann Constant
T = 300;                %Temp = 300 Kelvin
Cu = logspace(-11,-15)

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

n = 1:1:N;

figure
plot(n,f,'-s')
xlabel('Cycle')
ylabel('Fnp,cap')

f_ave = mean(f)
f = (f_ave*k*T)./(2^N.*Cu);
figure
semilogx(Cu,f)
xlabel('Unit Capacitance [Cu]')
ylabel('Noise Power [V^2]')


