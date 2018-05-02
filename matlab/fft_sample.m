tic
Fs = 1000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector

% S = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);
S = sin(2*pi*120*t);
% buff_ffts = zeros(100,length(S));
buff_SNDR = zeros(1,100);
for i = 1:100
    X = S + 2*randn(size(t));
%     Y = fft(X);
    buff_SNDR(i) = sinad(X); 
%     buff_ffts(i,:) = Y; 
end

% Y = mean(buff_ffts);
% f = Fs*(0:(L/2))/L;
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% 
% 
% plot(f,P1)
% 
% 
% title('Single-Sided Amplitude Spectrum of S(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
mean(buff_SNDR)
toc