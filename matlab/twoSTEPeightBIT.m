tic
    DNLarray = zeros(100,256);
    INLarray = zeros(100,256);
    for k = 1:1
        Cu = 1;
        sigma_Cu = 0.05;
        Vout = zeros(1,256);
        breakpoint = 0;
        format long g
        for Vin = 1:255
            Din = decimalToBinaryVector(Vin,8,'MSBFirst');
            breakpoint = get_BreakPoint(Vin);



            Ccurrent1 = [normrnd(Cu,Cu*sigma_Cu/sqrt(1)) normrnd(Cu,Cu*sigma_Cu/sqrt(1))];
            Ccurrent2 = [normrnd(Cu,Cu*sigma_Cu/sqrt(1)) normrnd(Cu,Cu*sigma_Cu/sqrt(1))];
            Cup1 = [0 1];
                if breakpoint == 1
                    Vout(Vin+1) = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2));
                    %Vout(Vin+1)
                    continue
                end

            Ccurrent1 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) Ccurrent1];
            Ccurrent2 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) Ccurrent2];
                if Din(1) == 1
                   Cup1 = [1 Cup1];
                else
                   Cup1 = [0 Cup1];
                end
                if breakpoint == 2
                    Vout(Vin+1) = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2)) ;
                    %Vout(Vin+1)
                    continue
                end

            Cup1 = [Cup1(1) Cup1];
                if Din(2) == 1
                   Cup1 = [1 Cup1];
                else
                   Cup1 = [0 Cup1];
                end
            Ccurrent1 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) Ccurrent1];
            Ccurrent2 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) Ccurrent2];
                if breakpoint == 3
                    Vout(Vin+1) = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2)) ;
                    %Vout(Vin+1)
                    continue
                end        


            Cup1 = [Cup1(1) Cup1(2) Cup1];
                if Din(3) == 1
                   Cup1 = [1 Cup1];
                else
                   Cup1 = [0 Cup1];
                end
            Ccurrent1 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(4*Cu,4*Cu*sigma_Cu/sqrt(4)) Ccurrent1];   
            Ccurrent2 = [normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(2*Cu,2*Cu*sigma_Cu/sqrt(2)) normrnd(4*Cu,4*Cu*sigma_Cu/sqrt(4)) Ccurrent2];
                if breakpoint == 4
                    Vout(Vin+1) = (sum(Cup1.*Ccurrent1) + sum(Cup1.*Ccurrent2))/(sum(Ccurrent1) + sum(Ccurrent2)) ;
                    %Vout(Vin+1)
                    continue
                end


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

                Cdac2 = [Ccurrent2(8)];
                if UpBound == 2
                    Cdac1 = [Ccurrent1(7)];
                else
                    Cdac1 = [Ccurrent1(8)]; 
                end
                if breakpoint == 5
                    Vout(Vin+1) = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1));
                    %Vout(Vin+1)
                    continue
                end

                    if (Din(5) == 1 && UpBound == 1) || (Din(5) == 0 && UpBound == 2)
                        Cdac1 = [Ccurrent1(6) Cdac1];
                    else
                        Cdac2 = [Ccurrent2(6) Cdac2];
                    end
                if breakpoint == 6
                    Vout(Vin+1) = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1));
                    %Vout(Vin+1)
                    continue
                end

                    if length(Cdac2) == 2
                        Cdac2 = [Ccurrent2(5) Cdac2];
                    end
                    if length(Cdac1) == 2
                        Cdac1 = [Ccurrent1(5) Cdac1];
                    end

                    if (Din(6) == 1 && UpBound == 1) || (Din(6) == 0 && UpBound == 2)
                        Cdac1 = [Ccurrent1(4) Cdac1];
                    else
                        Cdac2 = [Ccurrent2(4) Cdac2];
                    end
                if breakpoint == 7
                    Vout(Vin+1) = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1));
                    %Vout(Vin+1)
                    continue
                end

                    if length(Cdac2) == 2
                        Cdac2 = [Ccurrent2(2) Cdac2];
                    elseif length(Cdac2) == 3
                        Cdac2 = [Ccurrent2(3) Cdac2];
                    elseif length(Cdac2) == 4
                        Cdac2 = [Ccurrent2(2) Ccurrent2(3) Cdac2];
                    end

                    if length(Cdac1) == 2
                        Cdac1 = [Ccurrent1(2) Cdac1];
                    elseif length(Cdac1) == 3
                        Cdac1 = [Ccurrent1(3) Cdac1];
                    elseif length(Cdac1) == 4
                        Cdac1 = [Ccurrent1(2) Ccurrent1(3) Cdac1];
                    end

                    if (Din(7) == 1 && UpBound == 1) || (Din(7) == 0 && UpBound == 2)
                        Cdac1 = [Ccurrent1(1) Cdac1];
                    else
                        Cdac2 = [Ccurrent2(1) Cdac2];
                    end

                    Vout(Vin+1) = (V1*sum(Cdac1) + V2*sum(Cdac2))/(sum(Cdac2) + sum(Cdac1));    
        end
    LSB = (Vout(256)-Vout(1))/255;

                for u = 1:255
                   DNLarray(k,u) = ((Vout(u+1)-Vout(u)) - LSB)/LSB;
                end
                DNLarray(k,256) = ((1-Vout(255)) - LSB)/LSB;
            for u = 1:255
                for v = 1:u
                    INLarray(k,u) = INLarray(k,u) + DNLarray(k,v);
                end
            end
    end
    DNLstddev = zeros(1,255);
    INLstddev = zeros(1,255);
        for y = 1:256
           DNLstddev(y) = sqrt(var(DNLarray(:,y)));
           INLstddev(y) = sqrt(var(INLarray(:,y)));
        end
toc

function y = get_BreakPoint(Vin)
    %inputs : Vin in decimal format
    %returns: breakpoint

    N = 8;
    breakpoint = 1;
    while(mod(Vin, 2^(N-1)) | (N == 0))
        breakpoint = breakpoint + 1; 
        N = N - 1;
    end
    y = breakpoint;
end