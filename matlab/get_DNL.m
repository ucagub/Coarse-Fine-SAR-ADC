function y = get_DNL(DAC)
%usage : get_DNL(DAC) where DAC is the DAC object
%returns an array containing the DNL
    N = DAC.res;
    dnl = [];
    prev = 0;
    for i = 1:2^N-1
        dnl = [dnl DNL(DAC.eval(i), prev, DAC)];
        prev = DAC.eval(i);
    end
    y = dnl;
end

function y = DNL(u, v, DAC)
%DNL per step
%usage : DNL(output_next_step, output_prev_step, N)
%N is resolution
    N = DAC.res;
    Vref = DAC.Vref;
%     LSB = (DAC.eval(2^N-1)-DAC.eval(0))/2^N-1;
%     y = ((u-v) - LSB)/LSB;
    LSB = (DAC.eval(2^N-1)-DAC.eval(0))/(2^N-1);
    %LSB = 1/2^N;
    y = (u-v)/LSB - 1;
end