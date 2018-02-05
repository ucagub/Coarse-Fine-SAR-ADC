function y = Ecoarse_dac(coarse_dac, N)
    %inputs : coarse_dac object
    %       : k skip_bits
    %       : N resolution
    %returns: coarse_dac Epercycle
    bit_remain = N-coarse_dac.res;
    buff = zeros(1, 2^N);
    if strcmp(coarse_dac.type, 'CS_DAC')
        for i = 0:2^N-1
            %i
            buff(i+1) = coarse_dac.Epercycle(floor(i/(2^bit_remain)) +1);
        end
    elseif strcmp(coarse_dac.type, 'CS_DAC')
        for i = 0:2^N-2
            %i
            buff(i+1) = coarse_dac.Epercycle(floor(i/(2^bit_remain)) +1);
        end
        buff(2^N) = buff(1);
    end
    
    y = buff;
end