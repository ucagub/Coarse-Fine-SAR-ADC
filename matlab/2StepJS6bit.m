
Vin = 5;      
format long g
Carray1 = [2 2 2 1 1];
Carray2 = [2 2 2 1 1];
Ctotal = sum(Carray1);
Cup1 = [0 1];
Ccurrent1 = [1 1];
Din = decimalToBinaryVector(Vin,6,'MSBFirst')
Vout = sum(Cup1.*Ccurrent1)/sum(Ccurrent1);
Ccurrent1 = [2 1 1]      
    if Din(1) == 1
       Cup1 = [1 Cup1];
    else
       Cup1 = [0 Cup1];
    end
Vout = sum(Cup1.*Ccurrent1)/sum(Ccurrent1);
    Cup1 = [Cup1(1) Cup1];
    if Din(2) == 1
       Cup1 = [1 Cup1];
    else
       Cup1 = [0 Cup1];
    end
    Ccurrent1 = [2 2 2 1 1];
Vout = sum(Cup1.*Ccurrent1)/sum(Ccurrent1);
Ccurrent2 = Ccurrent1;
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

Vout = (V1+V2)/2;    

    if Din(3) == 1
        Ccurrent1 = [1];
        Cup1fine = [0];
        Ccurrent2 = [1];
        Cup2fine = [1];
    else
        Ccurrent1 = [1];
        Cup1fine = [1];
        Ccurrent2 = [1];
        Cup2fine = [0];
    end
    

    if (Din(4) == 1 && UpBound == 1) || (Din(4) == 0 && UpBound == 2)
        Ccurrent1 = [2 1];
    else
        Ccurrent2 = [2 1];
    end
    
    Vout = (V1*sum(Ccurrent1) + V2*sum(Ccurrent2))/(sum(Ccurrent2) + sum(Ccurrent1))

    if (Din(4) == 1 && UpBound == 1) || (Din(4) == 0 && UpBound == 2)
        Ccurrent1 = [2 1];
    else
        Ccurrent2 = [2 1];
    end
    Vout = (V1*sum(Ccurrent1) + V2*sum(Ccurrent2))/(sum(Ccurrent2) + sum(Ccurrent1));
    
    if length(Ccurrent2) == 2
        Ccurrent2 = [2 2 1];
    end
    if length(Ccurrent1) == 2
        Ccurrent1 = [2 2 1];
    end
    
    if (Din(5) == 1 && UpBound == 1) || (Din(5) == 0 && UpBound == 2)
        Ccurrent1 = [2 Ccurrent1];
    else
        Ccurrent2 = [2 Ccurrent2];
    end
    
    Vout = (V1*sum(Ccurrent1) + V2*sum(Ccurrent2))/(sum(Ccurrent2) + sum(Ccurrent1))
    
    