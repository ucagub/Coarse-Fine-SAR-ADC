function y = CS_DAC_mismatch(u)
%input : code in decimal format
%output : output voltage for the input code
%8 bit CS_DAC
    
    Cap = 1e-15;
    Cu = 1*Cap;
    sigma_Cu = 0.05;
    
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
    Vup = 256;
    Vdown = 0;
    Vin = (u);
    code_up = [1 1 1 1 1 1 1 1];
    code_down = [0 0 0 0 0 0 0 0];
    Cmin = 1e-15;

    Vi = zeros(1,16);
    Etotal = 0;
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

    Vout = Vref*(code_up*Cupm' + code_down*Cdownm')/sum(Cupm+Cdownm);
    y = Vout;
    %y = Etotal;
end