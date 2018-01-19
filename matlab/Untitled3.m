Vin = 129;
Vref = 1;
Vup = 256;
Vdown = 0;
Carray = [2^7 2^6 2^5 2^4 2^3 2^2 2^1 2^0 1];
code_cycle = [0];
for i = 0:7
       code_cycle = [code_cycle (Vup+Vdown)/2];
       if Vin > (Vup+Vdown)/2
           Vdown = (Vup+Vdown)/2;

       else 
           Vup = (Vup+Vdown)/2;

       end
end

code_cycle
i = 2;
Vf = Vcycle(i+1) - Vref;
Vi = [Vcycle(i) - de2bi(code_cycle(i), 8)*-Vref 0];
Ecurr = -Vref*([fliplr(de2bi(code_cycle(i+1), 8)) 0])*(Carray.*[Vf - Vi])'

