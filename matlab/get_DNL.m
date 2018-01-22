function y = get_DNL(DAC)
%usage : get_DNL(DAC) where DAC is the DAC object
%returns an array containing the DNL
    dnl = [];
    prev = 0;
    for i = 1:255
        dnl = [dnl DNL(DAC.eval(i), prev)];
        prev = DAC.eval(i);
    end
    y = dnl;
end

function y = DNL(u, v)
%DNL per step
%usage : DNL(output_next_step, output_prev_step)
    Vref = 1;
    N = 8;
    LSB = Vref/2^N;
    y = ((u-v) - LSB)/LSB;
end