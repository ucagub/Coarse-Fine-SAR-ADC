maxDNL = zeros(1,10);
maxINL = zeros(1,10);
for z = 1:10
    sigma_Cu = z/100;
    DNLarray = zeros(1000,256);
    INLarray = zeros(1000,256);
    for x = 1:1000
            Cap = 1e-15;
            Cu = 1*Cap;


            resolution = 8;
            LSB = 1/2^resolution;
            Cup = [2^6 2^5 2^4 2^3 2^2 2^1 2^0 1];
            Cdown = [2^6 2^5 2^4 2^3 2^2 2^1 2^0 1];
            Carray = [Cup Cdown];

            %initialize Cupm Cdownm
            Cupm = Cup;
            Cdownm = Cdown;

            for a = 1:8
                sigma = Cu*Cup(a)*sigma_Cu/sqrt(Cup(a));
                Cupm(a) = normrnd(Cu*Cup(a),sigma);
            end
            for a = 1:8
                sigma = Cu*Cdown(a)*sigma_Cu/sqrt(Cdown(a));
                Cdownm(a) = normrnd(Cu*Cdown(a),sigma);
            end
            %Cupm
            %Cdownm

            Vref = 1;
            Vout = zeros(1,256);

         for Vin = 0:255
            Vup = 256;
            Vdown = 0;
            code_up = [1 1 1 1 1 1 1 1];
            code_down = [0 0 0 0 0 0 0 0];
            Cmin = 1e-15;

            Vi = zeros(1,16);
            code_cycle = [];
            for i = 1:8
                %Vout = Vref*(code_up*Cup' + code_down*Cdown')/(2^8);
                code_cycle = [code_cycle (Vup+Vdown)/2];

                if Vin > (Vup+Vdown)/2
                   Vdown = (Vup+Vdown)/2;
                   code_down(i) = 1;
                elseif Vin < (Vup+Vdown)/2
                   Vup = (Vup+Vdown)/2;
                   code_up(i) = 0;
                else
                    %Vout = (Vup+Vdown)/2;
                    break;
                end 
            end

            Vout(Vin+ 1) = Vref*(code_up*Cupm' + code_down*Cdownm')/sum(Cupm+Cdownm);
         end
            DNL = zeros(1,256);
            INL = zeros(1,256);
            output_code = [0:1:255];
        for u = 1:255
           DNL(u) = ((Vout(u+1)-Vout(u)) - LSB)/LSB;
           DNLarray(x,u) = DNL(u);
        end
        DNL(256) = ((1-Vout(256)) - LSB)/LSB;
        for u = 1:255
            for v = 1:u
                INL(u) = INL(u) + DNL(v);
                INLarray(x,u) = INL(u);
            end
        end

    end

    DNLstddev = zeros(1,256);
    INLstddev = zeros(1,256);
    for y = 1:256
       DNLstddev(y) = sqrt(var(DNLarray(:,y)));
       INLstddev(y) = sqrt(var(INLarray(:,y)));
    end
    maxDNL(z) = max(DNLstddev);
    maxINL(z) = max(INLstddev);

end
figure;
plot([0.01:0.01:0.1],maxDNL)
figure;
plot([0.01:0.01:0.1],maxINL)
