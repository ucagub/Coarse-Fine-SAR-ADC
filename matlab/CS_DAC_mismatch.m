function y = CS_DAC_mismatch(u)
%input : code in decimal format
%output : output voltage for the input code
%8 bit CS_DAC
    resolution = 8;
    LSB = 1/2^resolution;
    mu = 0;
    sigma = LSB;
    Cup = [2^6 2^5 2^4 2^3 2^2 2^1 2^0 1] + normrnd(mu,sigma,[1, resolution]);
    Cdown = [2^6 2^5 2^4 2^3 2^2 2^1 2^0 1] + normrnd(mu,sigma,[1, resolution]);
    Carray = [Cup Cdown];

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
        Vout = Vref*(code_up*Cup' + code_down*Cdown')/(2^8);
        code_cycle = [code_cycle (Vup+Vdown)/2];

        %Vcap_up = Vout - code_up*Vref;
        %Vcap_down = Vout - code_down*Vref;
        %Vf = [Vcap_up Vcap_down];
        %Vf.*[code_up code_down];

        %Ecycle = -Vref*(Carray*((Vf-Vi).*[code_up code_down])');
        %Etotal = Etotal + Ecycle;

        %Vi = Vf;
        if Vin > (Vup+Vdown)/2
           Vdown = (Vup+Vdown)/2;
           code_down(i) = 1;
        elseif Vin < (Vup+Vdown)/2
           Vup = (Vup+Vdown)/2;
           code_up(i) = 0;
        else
            Vout = (Vup+Vdown)/2;
            break;
        end 
    end

    Vout = Vref*(code_up*Cup' + code_down*Cdown')/(2^8);
    y = Vout;
    %y = Etotal;
end
