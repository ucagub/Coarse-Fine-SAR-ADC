Videal = (1/64)*[1:2:64];
a = 1;
Cu = 1;
sigma_Cu = 0.05;
for Vin = 1:2:64 
    format long g
    Cup1 = [0 1];
    Ccurrent1 = [normrnd(1,sigma_Cu) normrnd(1,sigma_Cu)];
    Din = decimalToBinaryVector(Vin,6,'MSBFirst');
    %Vout = sum(Cup1.*Ccurrent1)/sum(Ccurrent1);
    Ccurrent1 = [normrnd(2,sigma_Cu/sqrt(2)) Ccurrent1];    
        if Din(1) == 1
           Cup1 = [1 Cup1];
        else
           Cup1 = [0 Cup1];
        end
    %Vout = sum(Cup1.*Ccurrent1)/sum(Ccurrent1);
        Cup1 = [Cup1(1) Cup1];
        if Din(2) == 1
           Cup1 = [1 Cup1];
        else
           Cup1 = [0 Cup1];
        end
        Ccurrent1 = [normrnd(2,sigma_Cu/sqrt(2)) normrnd(2,sigma_Cu/sqrt(2)) Ccurrent1];
    %Vout = sum(Cup1.*Ccurrent1)/sum(Ccurrent1);
    Ccurrent2 = [2 2 2 1 1];
    for i = 1:5
        Ccurrent2(i) = normrnd(Ccurrent2(i),sigma_Cu/sqrt(Ccurrent2(i)));
    end
    Cup2 = Cup1;
    
        if Din(3) == 1
            Cup2(4) = 1;
            UpBound = 2;
        else
            Cup2(5) = 0;
            UpBound = 1;
        end
        
    V1 = sum(Cup1.*Ccurrent1)/sum(Ccurrent1);
    V2 = sum(Cup2.*Ccurrent2)/sum(Ccurrent2);

    %Vout = (V1+V2)/2;    
    Cdac1 = [Ccurrent1(5)];
    Cdac2 = [Ccurrent2(5)];

        if (Din(4) == 1 && UpBound == 1) || (Din(4) == 0 && UpBound == 2)
            Cdac1 = [Ccurrent1(3) Cdac1];
        else
            Cdac2 = [Ccurrent2(3) Cdac2];
        end

        %Vout = (V1*sum(Ccurrent1) + V2*sum(Ccurrent2))/(sum(Ccurrent2) + sum(Ccurrent1));

        if length(Cdac2) == 2
            Cdac2 = [Ccurrent2(2) Cdac2];
        end
        if length(Cdac1) == 2
            Cdac1 = [Ccurrent1(2) Cdac1];
        end

        if (Din(5) == 1 && UpBound == 1) || (Din(5) == 0 && UpBound == 2)
            Cdac1 = [Ccurrent1(1) Cdac1];
        else
            Cdac2 = [Ccurrent2(1) Cdac2];
        end

        Vout(a) = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1));
        a = a + 1;
end
