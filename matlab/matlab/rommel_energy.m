for C = 1e-12:1e-12:10e-12
    Energy = zeros(1,256)
    for a = 0:255
        Vin = a;
        Vref = 1;
        Vup = 256;
        Vdown = 0;
        Vout = 0;
        Carray = C*[2^0 2^1 2^2 2^3 2^4 2^5 2^6 2^7];
        Vcap = zeros(1,8);
        for i = 0:7
              Cup = find(decimalToBinaryVector((Vup+Vdown)/2,8,'LSBFirst'));
              k = size(Cup);
              j = k(2);

              for l = 1:j
                  Energy(a+1) = Energy(a+1) + -1*Carray(Cup(l))*((((Vup+Vdown)/2)-256)-Vcap(Cup(l)));
                  Vcap(Cup(l)) = ((Vup+Vdown)/2)-256;
              end

              Cdown = find(decimalToBinaryVector((Vup+Vdown)/2,8,'LSBFirst')==0);
              k = size(Cdown);
              j = k(2);
              for l = 1:j
                  Vcap(Cdown(l)) = ((Vup+Vdown)/2);
              end

               if Vin >= (Vup+Vdown)/2
                   Vdown = (Vup+Vdown)/2;
               else 
                   Vup = (Vup+Vdown)/2;
               end
        end
    end
    AvgEnergy = mean((Energy)/256);
    output_code = [0:1:255];
    plot(output_code,(Energy)/256)
    hold on
end
