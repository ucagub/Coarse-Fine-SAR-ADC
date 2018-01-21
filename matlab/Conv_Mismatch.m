Vout = zeros(1,256);
Cap = 1e-15;
Cu = 1*Cap;
sigma_Cu = 0.02;
LSB = 1/2^8;
Carray = Cu.*[2^7 2^6 2^5 2^4 2^3 2^2 2^1 2^0];
Ctot = 256*Cap;
for Vin = 0:255
    
        Din = decimalToBinaryVector(Vin,8,'MSBFirst');
        Cup_tot = 0;
        Cup = find(Din);
                  i = size(Cup);
                  j = i(2);
                  for k = 1:j
                      Cup_tot = Cup_tot + Carray(Cup(k));
                  end
                 
                  Cup_tot_sigma = sqrt(Cup_tot/Cap)*Cu*sigma_Cu;
                  Cup_tot
                  Cup_tot_sigma
                  R = normrnd(Cup_tot,Cup_tot_sigma);
        Vout(Vin+1) = R/normrnd(Ctot,sqrt(Ctot/Cap)*Cu*sigma_Cu);
  
end
DNL = zeros(1,256);
output_code = [0:1:255];
for u = 1:255
   DNL(u) = ((Vout(u+1)-Vout(u)) - LSB)/LSB;
end
DNL(256) = ((1-Vout(256)) - LSB)/LSB;

plot(output_code,DNL)
