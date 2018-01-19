%{
samples = 1e6;
sig = -1 + 2*rand(1,samples) + normrnd(0,sqrt(0.05),[1,samples]);
histogram(sig, 'Normalization', 'pdf')
%}

%{
Vref = 1;
mu = 0;
sigma = 0.3;
sig = [0:0.001:Vref];
error = 1 - cdf('Normal', -sig,mu, sigma);
error = [fliplr(error) error];
x = [fliplr(-sig) sig];
plot(x,error)
%}

%input
Vref = 1;
sig = [-2:.001:2];
mu = 0;
sigma = 0.05;
pdf = (1/2*Vref)*(cdf('Normal', sig+Vref,mu, sigma) - cdf('Normal', sig-Vref,mu, sigma) );
plot(sig,pdf)
