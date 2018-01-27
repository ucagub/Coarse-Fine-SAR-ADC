DNLarray = [];
INLarray = [];
DNL = [];
Vout = [];
total_DNL = [];
maxCode = [];

for z = 1:1
    Cap = 1e-15;
    Cu = 1*Cap;
    sigma_Cu = 0.05;
    %Vout = zeros(1,256);
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
    
    Vref = 1;
    

    
    for Vin = 0:255
        Vup = 256;
        Vdown = 0;
        code_up = [1 1 1 1 1 1 1 1];
        code_down = [0 0 0 0 0 0 0 0];
        Cmin = 1e-15;
        for i = 1:8
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

        %Vout(Vin+1) = Vref*(code_up*Cupm' + code_down*Cdownm')/sum(Cupm+Cdownm);
        Vout = [Vout Vref*(code_up*Cupm' + code_down*Cdownm')/sum(Cupm+Cdownm)];
        if length(Vout)>1
            buff = ((Vout(end)-Vout(end-1)) - LSB)/LSB;
            if abs(buff) < 5
                DNL = [DNL buff];
            end
            
        end
    end
    total_DNL = [total_DNL DNL];
    DNL = [];
    Vout = [];
    
    %INL = zeros(1,256);
    %output_code = [0:1:255];
 
    
    %end
    %DNL(256) = ((1-Vout(256)) - LSB)/LSB;
    %figure;
    %stem(output_code,DNL)
%     for u = 1:255
%         for v = 1:u
%             INL(u) = INL(u) + DNL(v);
%         end
%     end
    %figure;
   % stem(output_code,INL)
   % figure;
    %plot(Vout)
    %DNLarray = [DNLarray;DNL];
    plot(total_DNL)
    
end

%find(total_DNL == max(total_DNL))
%histogram(total_DNL, 'Normalization','probability')