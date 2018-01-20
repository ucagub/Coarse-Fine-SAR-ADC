function y = get_INL(DAC)
%usage : get_INL(@DAC) where DAC is the DAC function name
%returns an array containing the INL
    res = 8; %resolution
    dnl = get_DNL(DAC);
    inl = [];
    for i = 1:2^res-1;
        inl = [inl sum(dnl(1:i))];
    end
    
    y = inl;    
end