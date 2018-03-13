N = 10;
k = 7;
% a = DAC(N, 1, k);

% plot(a.Epercycle)
% hold on
% c = DAC(N, 1);
% plot(c.Epercycle)
% 
% b = DAC(k, 1); 
% plot(b.Epercycle);
% hold off
tic
figure;
hold on
buffy = zeros(1,N-1);
buffx = [1:N-1];
for i = 1:length(buffy) 
    a = ADC(10, 5, buffx(i), 'JS_DAC', 1, 'CS_DAC', 1, 0, 0);
    buffy(i) = a.Emean;
    %plot(a.Etotal_dac);
end
stem(buffx, buffy)

for i = 1:length(buffx)
    text(buffx(i), buffy(i), ['  ' num2str(buffy(i))], 'FontSize', 16);
end
toc