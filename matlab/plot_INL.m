function y = plot_INL(DAC)
%plots the DNL of a DAC
%usage : plot_DNL(@DAC) where DAC is the DAC function

    plot(get_INL(DAC));

end