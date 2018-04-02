    Energy = zeros(1,1024);
    for a = 0:1023
        Vin = a;
        Vref = 1;
        Vup = 1024;
        Vdown = 0;
        Vout = 0;
        Carray = [2^0 2^1 2^2 2^3 2^4 2^5 2^6 2^7 2^8 2^9];
        Vcap = zeros(1,10);
        for i = 0:9
              Cup = find(decimalToBinaryVector((Vup+Vdown)/2,10,'LSBFirst'));
              k = size(Cup);
              j = k(2);

              for l = 1:j
                  Energy(a+1) = Energy(a+1) + -1*Carray(Cup(l))*((((Vup+Vdown)/2)-1024)-Vcap(Cup(l)));
                  Vcap(Cup(l)) = ((Vup+Vdown)/2)-1024;
              end

              Cdown = find(decimalToBinaryVector((Vup+Vdown)/2,10,'LSBFirst')==0);
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
    
      hold on
    output_code = [0:1:1023];
    plot(output_code,(Energy)/1024)
%     plot(0:1023,mean((Energy)/1024).*ones(1,1024))