Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 2^13;             % Length of signal
t = (0:L-1)*T;        % Time vector

S = 1e6*sin(2*pi*120*t);
X = S + 2*randn(size(t));

Y = fft(X);

f = Fs*(0:(L/2))/L;

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
plot(f,P1)
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

SNDR = 10*log10(P1(984)^2/(sum(P1(1:983).^2)+sum(P1(985:L/2).^2)))
sinad(X)
ENOB = (SNDR-1.76)/6.02