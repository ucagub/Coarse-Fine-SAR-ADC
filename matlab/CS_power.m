Cup = [2^6 2^5 2^4 2^3 2^2 2^1 2^0 1];
Cdown = [2^6 2^5 2^4 2^3 2^2 2^1 2^0 1];
Vref = 1;
Vup = 256;
Vdown = 0;
Vin = 5;
code_up = [1 1 1 1 1 1 1 1];
code_down = [0 0 0 0 0 0 0 0];
Cmin = 1e-15;
code_cycle = [];
for i = 1:8
       code_cycle = [code_cycle (Vup+Vdown)/2];
       if Vin >= (Vup+Vdown)/2
           Vdown = (Vup+Vdown)/2;
           code_down(i) = 1;
       else 
           Vup = (Vup+Vdown)/2;
           code_up(i) = 0;
       end 
end

Vout = Vref*(code_up*Cup' + code_down*Cdown')/(2^8)