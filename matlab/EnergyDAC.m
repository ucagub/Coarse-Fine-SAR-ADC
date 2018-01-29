
    Energy = zeros(1,256);
    for a = 0:255
        Vin = a;
        Vref = 1;
        Vup = 256;
        Vdown = 0;
        Vout = 0;
        Carray = [2^0 2^1 2^2 2^3 2^4 2^5 2^6 2^7];
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
    plot(0:255,mean((Energy)/256).*ones(1,256))
      hold on
    output_code = [0:1:255];
    plot(output_code,(Energy)/256)
  
    for Vin = 0:255
    Cup = [2^6 2^5 2^4 2^3 2^2 2^1 2^0 1];
    Cdown = [2^6 2^5 2^4 2^3 2^2 2^1 2^0 1];
    Carray = [Cup Cdown];

    Vref = 1;
    Vup = 256;
    Vdown = 0;
    code_up = [1 1 1 1 1 1 1 1];
    code_down = [0 0 0 0 0 0 0 0];
    Cmin = 1;

    Vi = zeros(1,16);
    Etotal(Vin+1) = 0;
    code_cycle = [];
    %code_prev = zeros(1,16);
        for i = 1:7
            Vout = Vref*(code_up*Cup' + code_down*Cdown')/(2^8);
            code_cycle = [code_cycle (Vup+Vdown)/2];

            Vcap_up = Vout - code_up*Vref;
            Vcap_down = Vout - code_down*Vref;
            Vf = [Vcap_up Vcap_down];
            %Vf.*[code_up code_down];

            Ecycle = -Vref*(Carray*((Vf-Vi).*[code_up code_down])');
            Etotal(Vin+1) = Etotal(Vin+1) + Ecycle;

            Vi = Vf;
            if Vin >= (Vup+Vdown)/2
               Vdown = (Vup+Vdown)/2;
               code_down(i) = 1;
            else 
               Vup = (Vup+Vdown)/2;
               code_up(i) = 0;
            end 
        end
    end
    plot(0:255,Etotal)
    plot(0:255,mean(Etotal).*ones(1,256))
    
    
    
    Cu = 1;
    sigma_Cu = 0.000;
    Vout = zeros(1,256);
    format long g
    Energy = zeros(1,256);
    EnergyCoarse = zeros(1,256);
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
            EnergyCoarse(Vin+1) = Energy(Vin+1);
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
EnergyCoarse(Vin+1) = Energy(Vin+1);
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
                        Vi1(i) = Vf-1;
                    end
                end
                for i = 1:length(Cdac2)
                    if Cdacup2(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Cdac2(i)*(Vf-1-Vi2(i));
                        Vi2(i) = Vf-1;
                    end
                end

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
                        Vi1(i) = Vf-1;
                    end
                end
                for i = 1:length(Cdac2)
                    if Cdacup2(i) == 1
                        Energy(Vin+1) = Energy(Vin+1) + -Cu*Cdac2(i)*(Vf-1-Vi2(i));
                        Vi2(i) = Vf-1;
                    end
                end
                Vout(Vin+1) = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1));   
                
    end
    plot(0:255,Energy)
    plot(0:255,mean(Energy).*ones(1,256))
    
    xlabel('output code')
    ylabel('Switching Energy')
    legend('Avg. Conv','Conv','CapSplit','Avg. CapSplit','2-step JS','Avg 2-step JS')





    