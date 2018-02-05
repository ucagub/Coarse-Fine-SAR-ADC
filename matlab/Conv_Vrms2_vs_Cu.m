k = 1.3087 * 10^-23;    %Boltzmann Constant
T = 300;                %Temp = 300 Kelvin
Cu = logspace(-11,-15)


f = (1.6*k*T)./((2^8).*Cu);
semilogx(Cu,f)

xlabel('Unit Capacitance [Cu]')
ylabel('Noise Power [V^2]')
