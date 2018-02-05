
N               = 8;
f_sampling      = 3.15e5;
f_input         = 100;
f_clk           = 1e3;
Vdd             = 1;
clock_duty      = 50;
time            = 4/f_input;   

output  = zeros(1,time*f_sampling + 1);
t       = [0: 1/f_sampling: time];
input   = 0.5*(sin(2*pi*f_input*t)+1);
%input   = .5*(square(2*pi*f_input*t,50)+1);
clk     = .5*(square(2*pi*f_clk*t,clock_duty)+1);

DAC_in = 0;
DAC = multistep_CS('test',0.0);
D_out = zeros(1,N);
tic
for k = 1:length(input)
    D_out = zeros(1,N);
    for i = 1:N
        D_out(i) = 1;
        DAC_in = bi2de(D_out, 'left-msb') / 2^N ;
        if input(k) < DAC.eval(DAC_in)
            D_out(i) = 0;
        end
    end
    
    output(k) = bi2de(D_out, 'left-msb') / 2^N ;
end
toc

sndr = sinad(output, f_sampling);
enob = (sndr-1.76)/6.02;
