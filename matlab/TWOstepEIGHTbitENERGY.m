
    Cu = 1;
    sigma_Cu = 0.000;
    Vout = zeros(1,256);
    format long g
    Energy = zeros(1,256);
    EnergyCoarse = zeros(1,256);
    Energy8 = zeros(1,256);
    Energy7 = zeros(1,256);
    for Vin = 0:255
        Din = decimalToBinaryVector(Vin,8,'MSBFirst');

        Ccurrent1 = [normrnd(Cu,Cu*sigma_Cu/sqrt(1)) normrnd(Cu,Cu*sigma_Cu/sqrt(1))];
        Ccurrent2 = [normrnd(Cu,Cu*sigma_Cu/sqrt(1)) normrnd(Cu,Cu*sigma_Cu/sqrt(1))];
        Cup1 = [0 1];
        Vf = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2));
        Vi = 0;
        Energy(Vin+1) = -2*Cu*(Vf-1);
        Vi = Vf - 1 ;
            
        Ccurrent1 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) Ccurrent1];
        Ccurrent2 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) Ccurrent2];
            if Din(1) == 1
               Cup1 = [1 Cup1];
               Vf = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2));
               Energy(Vin+1) = Energy(Vin+1) + -2*2*Cu*(Vf-1) + -2*Cu*(Vf-1-Vi); 
            else
               Cup1 = [0 Cup1];
               Vf = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2));
               Energy(Vin+1) = Energy(Vin+1) + -2*Cu*(Vf-1-Vi); 
            end
            Vi = Vf - 1;

        Cup1 = [Cup1(1) Cup1];
        Ccurrent1 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) Ccurrent1];
        Ccurrent2 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) Ccurrent2];

            if Din(2) == 1
               Cup1 = [1 Cup1];
               if Cup1(2) == 1
                   Vf = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2));
                   Energy(Vin+1) = Energy(Vin+1) + -2*2*Cu*(Vf-1) + -2*2*Cu*(Vf-1) + -2*2*Cu*(Vf-1-Vi) + -2*Cu*(Vf-1-Vi); 
               else
                   Vf = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2));
                   Energy(Vin+1) = Energy(Vin+1) + -2*2*Cu*(Vf-1) + -2*Cu*(Vf-1-Vi);                    
               end
            else
               Cup1 = [0 Cup1];
               if Cup1(2) == 1
                   Vf = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2));
                   Energy(Vin+1) = Energy(Vin+1) + -2*2*Cu*(Vf-1) + -2*2*Cu*(Vf-1-Vi) + -2*Cu*(Vf-1-Vi); 
               else
                   Vf = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2));
                   Energy(Vin+1) = Energy(Vin+1) + -2*Cu*(Vf-1-Vi);                    
               end
            end
            Vi = Vf-1;
        Ccurrent1 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(4*Cu,4*Cu*sigma_Cu/sqrt(4)) Ccurrent1];   
        Ccurrent2 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(4*Cu,4*Cu*sigma_Cu/sqrt(4)) Ccurrent2];
        Cup1 = [Cup1(1) Cup1(2) Cup1];
        
            if Din(3) == 1
               Cup1 = [1 Cup1];
            else
               Cup1 = [0 Cup1];
            end
            Vf = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2));
            for i = 1:length(Ccurrent1)
                if i == 1 || i == 2 || i == 3
                    if Cup1(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -2*Ccurrent1(i)*Cu*(Vf-1);
                    end
                else
                    if Cup1(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -2*Ccurrent1(i)*Cu*(Vf-1-Vi);
                    end
                end
            end
            
            Vi = Vf-1;
        Cup2 = Cup1;

            if Din(4) == 1
                Cup2(7) = 1;
                UpBound = 2;
            else
                Cup2(8) = 0;
                UpBound = 1;
            end
         
        V1 = sum(Cup1.*Ccurrent1)/sum(Ccurrent1);
        V2 = sum(Cup2.*Ccurrent2)/sum(Ccurrent2);
            for i = 1:length(Ccurrent2)
                if Cup2(i) == 1
                    if i == 7 && UpBound == 2
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Ccurrent2(i)*(V2-1-V1);
                    else
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Ccurrent2(i)*(V2-1-(V1-1));
                    end
                end
            end

            Cdac2 = [Ccurrent2(8)];
            Cdacup2 = [Cup2(8)];
            
                
            if UpBound == 2
                Cdac1 = [Ccurrent1(7)];
                Cdacup1 = [Cup1(7)];
            else
                Cdac1 = [Ccurrent1(8)]; 
                Cdacup1 = [Cup1(8)];
            end
                Vi1 = [V1-1];
                Vi2 = [V2-1];
                Vf = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1));
                for i = 1:length(Cdac1)
                    if Cdacup1(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Cdac1(i)*(Vf-1-Vi2(i));
                        Vi1(i) = Vf-1;
                    end
                end
                for i = 1:length(Cdac2)
                    if Cdacup2(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Cdac2(i)*(Vf-1-Vi2(i));
                        Vi2(i) = Vf-1;
                    end
                end
                
                if (Din(5) == 1 && UpBound == 1) || (Din(5) == 0 && UpBound == 2)
                    Cdac1 = [Ccurrent1(6) Cdac1];
                    Cdacup1 = [Cup1(6) Cdacup1];
                    Vi1 = [V1-1 Vi1];
                else
                    Cdac2 = [Ccurrent2(6) Cdac2];
                    Cdacup2 = [Cup2(6) Cdacup2];
                    Vi2 = [V2-1 Vi2];
                end
                Vf = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1));
                for i = 1:length(Cdac1)
                    if Cdacup1(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Cdac1(i)*(Vf-1-Vi1(i));
                        Vi1(i) = Vf-1;
                    end
                end
                for i = 1:length(Cdac2)
                    if Cdacup2(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Cdac2(i)*(Vf-1-Vi2(i));
                        Vi2(i) = Vf-1;
                    end
                end                
                EnergyCoarse(Vin+1) = Energy(Vin+1);
                if length(Cdac2) == 2
                    Cdac2 = [Ccurrent2(5) Cdac2];
                    Cdacup2 = [Cup2(5) Cdacup2];
                    Vi2 = [V2-1 Vi2];
                end
                if length(Cdac1) == 2
                    Cdac1 = [Ccurrent1(5) Cdac1];
                    Cdacup1 = [Cup1(5) Cdacup1];
                    Vi1 = [V1-1 Vi1];
                end

                if (Din(6) == 1 && UpBound == 1) || (Din(6) == 0 && UpBound == 2)
                    Cdac1 = [Ccurrent1(4) Cdac1];
                    Cdacup1 = [Cup1(4) Cdacup1];
                    Vi1 = [V1-1 Vi1];
                else
                    Cdac2 = [Ccurrent2(4) Cdac2];
                    Cdacup2 = [Cup2(4) Cdacup2];
                    Vi2 = [V2-1 Vi2];
                end
                Vf = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1));
                for i = 1:length(Cdac1)
                    if Cdacup1(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Cdac1(i)*(Vf-1-Vi1(i));
                        %Energy7(Vin+1) = Energy7(Vin+1) + -Cu*Cdac1(i)*(Vf-1-Vi1(i));
                        Vi1(i) = Vf-1;
                    end
                end
                for i = 1:length(Cdac2)
                    if Cdacup2(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Cdac2(i)*(Vf-1-Vi2(i));
                        %Energy7(Vin+1) = Energy7(Vin+1) + -Cu*Cdac2(i)*(Vf-1-Vi2(i));
                        Vi2(i) = Vf-1;
                    end
                end
                Energy7(Vin+1) = Energy(Vin+1);
                if length(Cdac2) == 2
                    Cdac2 = [Ccurrent2(2) Cdac2];
                    Cdacup2 = [Cup2(2) Cdacup2];
                    Vi2 = [V2-1 Vi2];
                elseif length(Cdac2) == 3
                    Cdac2 = [Ccurrent2(3) Cdac2];
                    Cdacup2 = [Cup2(3) Cdacup2];
                    Vi2 = [V2-1 Vi2];
                elseif length(Cdac2) == 4
                    Cdac2 = [Ccurrent2(2) Ccurrent2(3) Cdac2];
                    Cdacup2 = [Cup2(2) Cup2(3) Cdacup2];
                    Vi2 = [V2-1 V2-1 Vi2];
                end

                if length(Cdac1) == 2
                    Cdac1 = [Ccurrent1(2) Cdac1];
                    Cdacup1 = [Cup1(2) Cdacup1];
                    Vi1 = [V1-1 Vi1];
                elseif length(Cdac1) == 3
                    Cdac1 = [Ccurrent1(3) Cdac1];
                    Cdacup1 = [Cup1(3) Cdacup1];
                    Vi1 = [V1-1 Vi1];
                elseif length(Cdac1) == 4
                    Cdac1 = [Ccurrent1(2) Ccurrent1(3) Cdac1];
                    Cdacup1 = [Cup1(2) Cup1(3) Cdacup1];
                    Vi1 = [V1-1 V1-1 Vi1];
                end

                if (Din(7) == 1 && UpBound == 1) || (Din(7) == 0 && UpBound == 2)
                    Cdac1 = [Ccurrent1(1) Cdac1];
                    Cdacup1 = [Cup1(1) Cdacup1];
                    Vi1 = [V1-1 Vi1];
                else
                    Cdac2 = [Ccurrent2(1) Cdac2];
                    Cdacup2 = [Cup2(1) Cdacup2];
                    Vi2 = [V2-1 Vi2];
                end
                Vf = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1)); 
                for i = 1:length(Cdac1)
                    if Cdacup1(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Cdac1(i)*(Vf-1-Vi1(i));
                        Energy8(Vin+1) = Energy8(Vin+1) + -Cu*Cdac1(i)*(Vf-1-Vi1(i));
                    end
                end
                for i = 1:length(Cdac2)
                    if Cdacup2(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Cdac2(i)*(Vf-1-Vi2(i));
                        Energy8(Vin+1) = Energy8(Vin+1) + -Cu*Cdac2(i)*(Vf-1-Vi2(i));
                    end
                end
                Vout(Vin+1) = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1));   
                
    end


