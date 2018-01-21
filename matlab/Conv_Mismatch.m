

DNLarray = [];
INLarray = [];
for x = 1:1000
    Vout = zeros(1,256);
    Cap = 1e-15;
    Cu = 1*Cap;
    sigma_Cu = 0.05;
    LSB = 1/2^8;
    Cmm = zeros(1,8);

    Carray = Cu.*[2^0 2^1 2^2 2^3 2^4 2^5 2^6 2^7];
    for a = 1:8
        sigma = Carray(a)*sigma_Cu/sqrt(2^(a-1));
        Cmm(a) = normrnd(Carray(a),sigma);
    end
    Ctot = sum(Cmm) + normrnd(Cu,Cu*sigma_Cu);
    for Vin = 0:255

            Din = decimalToBinaryVector(Vin,8,'LSBFirst');
            Cup_tot = 0;
            Cup = find(Din);
                      i = size(Cup);
                      j = i(2);
                      for k = 1:j
                          Cup_tot = Cup_tot + Cmm(Cup(k));
                      end

            Vout(Vin+1) = Cup_tot/Ctot;

    end
    DNL = zeros(1,256);
    INL = zeros(1,256);
    output_code = [0:1:255];
    for u = 1:255
       DNL(u) = ((Vout(u+1)-Vout(u)) - LSB)/LSB;
    end
    DNL(256) = ((1-Vout(256)) - LSB)/LSB;
    %figure;
    %stem(output_code,DNL)
    for u = 1:255
        for v = 1:u
            INL(u) = INL(u) + DNL(v);
        end
    end
    %figure;
   % stem(output_code,INL)
   % figure;
    %plot(Vout)
    DNLarray = [DNLarray;DNL];
end

for y = 1:256
   stddev(y) = sqrt(var(DNLarray(:,y)));
end

