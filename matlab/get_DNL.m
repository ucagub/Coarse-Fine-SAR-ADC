function y = get_DNL(DAC)
%usage : get_DNL(@DAC) where DAC is the DAC function name
%returns an array containing the DNL
    dnl = [];
    prev = 0;
    for i = 1:255
        dnl = [dnl DNL(DAC(i), prev)];
        prev = DAC(i);
    end
    y = dnl;
end

function y = DNL(u, v)
%DNL per step
%usage : DNL(output_next_step, output_prev_step)

y = (u - v)*2^8 - 1;
end