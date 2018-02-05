function y = get_DNL_multistep_CS_6bit(DAC)
%usage : get_DNL(DAC) where DAC is the DAC object
%returns an array containing the DNL
    dnl = [];
    prev = 0;
    for i = 1:63
        dnl = [dnl DNL(DAC.eval(i/64), prev)];
        prev = DAC.eval(i/64);
    end
    y = dnl;
end

function y = DNL(u, v)
%DNL per step
%usage : DNL(output_next_step, output_prev_step)
    Vref = 1;
    N = 6;
    LSB = Vref/2^N;
    y = ((u-v) - LSB)/LSB;
end

