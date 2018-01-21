Vout = zeros(1,256);
Cu = 1e-12;
sigma_Cu = Cu*.01;
LSB = 1/2^8;
Carray = Cu.*[2^7 2^6 2^5 2^4 2^3 2^2 2^1 2^0];
Ctot = 256e-12;
for Vin = 0:255
    
        Din = decimalToBinaryVector(Vin,8,'MSBFirst');
        Cup_tot = 0;
        Cup = find(Din);
                  i = size(Cup);
                  j = i(2);
                  for k = 1:j
                      Cup_tot = Cup_tot + Carray(Cup(k));
                  end
                  Cup_tot_sigma = sqrt(Cup_tot)*Cu*sigma_Cu;
                  R = normrnd(Cup_tot,Cup_tot_sigma);
        Vout(Vin+1) = R/Ctot;
  
end
DNL = zeros(1,256);
output_code = [0:1:255];
for u = 1:255
   DNL(u) = (Vout(u+1)-Vout(u)) - LSB;
end
DNL(256) = (1-Vout(256)) - LSB;

plot(output_code,DNL)
