
%dac = DAC(8, .1);
f = 5e3;
t = [0:1e-10:1/f];
y = 0.5*sin(2*pi*f*t) + 0.5;
% t = [0:1e-7:1];
% y = t;
z = zeros(1,length(y));
for i = 1:length(y)
    z(i) = ideal_SAR(9, y(i));
end

%figure;
%hold on;
%plot(t,y)
%plot(t,z)
%plot(t,(y-z)*(2^8))
%figure;
c = snr(z)
b = sinad(z)
ENOB = (b-1.76)/6.02