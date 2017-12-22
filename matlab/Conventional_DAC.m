function y = Conventional_DAC(u)

%y(1) = u(1)*2^-1 + u(2)*2^-2 + u(3)*2^-3 + u(4)*2^-4 + u(5)*2^-5 + u(6)*2^-6 + u(7)*2^-7 + u(8)*2^-8;
resolution = 8;
Cmin = 1e-15;
Ctotal = Cmin*2^resolution;
%Carray = (Cmin*[2^7 2^6 2^5 2^4 2^3 2^2 2^1 2^0 1] + [u(9) u(10) u(11) u(12) u(13) u(14) u(15) u(16) 0])';
Carray = [1];

for i = 0:resolution-1
    Carray = [Carray 2^i]; 
end

y = (Cmin*[0 de2bi(u,resolution)]*Carray')/Ctotal;
%y(1) = [u(1) u(2) u(3) u(4) u(5) u(6) u(7) u(8)]*[2^-1 2^-2 2^-3 2^-4 2^-5 2^-6 2^-7 2^-8]';