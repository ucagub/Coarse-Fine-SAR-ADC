function y = plot_SINAD(DAC)
%usage : plot_SINAD(@DAC) where DAC is the DAC function name
%output : DAC SNDR plot and signal input plot
%default input signal is sin with freq = 500;
    f = 500;
    t = [0:1e-7:1/f];
    sig = sin(2*pi*f*t);
    DAC_in = (1+sig)*128; %normalized input to 0-256
    DAC_out = arrayfun(DAC, DAC_in);
    figure;
    plot(DAC_out)
    figure;
    sinad(DAC_out);
end
