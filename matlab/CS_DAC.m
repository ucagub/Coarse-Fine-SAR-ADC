function y = CS_DAC(u)

resolution = 8;
inCode = de2bi(u,resolution);
Cmin = 1e-15;
Ctotal = Cmin*2^resolution;
Carray = [1];

for i = 0:resolution-2
    Carray = [Carray 2^i]; 
end

y = (Cmin*[0 inCode]*Carray')/Ctotal;
