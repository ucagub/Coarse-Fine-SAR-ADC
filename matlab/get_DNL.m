function y = get_DNL(DAC)
%usage : get_DNL(DAC) where DAC is the DAC object
%returns an array containing the DNL
    N = DAC.res;
    dnl = [];
    prev = 0;
    for i = 1:2^N-1
        dnl = [dnl DNL(DAC.eval(i), prev, N)];
        prev = DAC.eval(i);
    end
    y = dnl;
end

function y = DNL(u, v, N)
%DNL per step
%usage : DNL(output_next_step, output_prev_step, N)
%N is resolution
    Vref = 1;
    LSB = Vref/2^N;
    y = ((u-v) - LSB)/LSB;
end