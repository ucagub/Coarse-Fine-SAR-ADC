function y = CS_DAC(u, v)
%usage : CS_DAC(input_code, resolution)

    resolution = v;
    inCode = de2bi(u,resolution);
    Cmin = 1e-15;
    Ctotal = Cmin*2^resolution;
    Carray = [1];

    for i = 0:resolution-2
        Carray = [Carray 2^i]; 
    end

    Cup = Carray;
    Cdown = Carray;

    if inCode(resolution) == 1
        Sup = zeros(1,resolution) + 1;
        Sdown = [0 inCode(1:resolution-1)];
    else
        Sup = [0 inCode(1:resolution-1)];
        Sdown = zeros(1,resolution);
    end


    y = (Cmin*(Sup*Cup' + Sdown*Cdown'))/Ctotal;
end