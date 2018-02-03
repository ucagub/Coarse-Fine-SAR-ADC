function y = ideal_quantizer(N, Vin)
    %inputs : N resolution
    %       : Vin input to be quantized
    %output : quantized value
    Vref = 1;
    LSB = Vref/(2^N);
    y = floor(Vin/LSB)*LSB;
end