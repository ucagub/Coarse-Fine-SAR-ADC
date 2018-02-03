function y = ideal_SAR(N, Vin)
    %inputs : N resolution
    %       : Vin input to be quantized
    %returns: quantized version of Vin
    Vref = 1;
    Vup = 2^N;
    Vdown = 0;
    LSB = Vref/2^N;
    for i = 1:N
        if Vin > LSB*((Vup+Vdown)/2)
            Vdown = (Vup+Vdown)/2;
        else
            Vup = (Vup+Vdown)/2;
        end 
    end
    y = LSB*((Vup+Vdown)/2);
end