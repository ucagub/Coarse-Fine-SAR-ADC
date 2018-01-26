classdef JS_DAC
    properties (Access = public)
        type
        Vref
        Carray
        Ctup
        Ctdown
        Vouts
        DNL
        INL
        %abs_max_DNL
        %DNL_stdev
        %value
    end
    properties (Access = private)
        Cupm
        Cdownm
        
    end
    methods
        function obj = JS_DAC(name)
            obj.type = name;
            obj.Vref = 1;
            %obj.value = randsd(1);
            obj.Ctup = 1;
            obj.Ctdown = 1;
            obj.Carray = [2 0 0 0 0 0 0; 
                          2 2 0 0 0 0 0; 
                          4 2 2 0 0 0 0;
                          8 4 2 2 0 0 0; 
                          16 8 4 2 2 0 0; 
                          32 16 8 4 2 2 0; 
                          64 32 16 8 4 2 2];
            obj.Ctup = add_mismatch(obj.Ctup);
            obj.Ctdown = add_mismatch(obj.Ctdown);
            
            for a = 1:7
                for b = 1:a
                    obj.Carray(a,b) = add_mismatch(obj.Carray(a,b));
                end
            end
            obj.Vouts = get_Vouts(obj);
            obj.DNL = get_DNL(obj);
            obj.INL = get_INL(obj);
            %obj.abs_max_DNL = max(abs(obj.DNL));
            %obj.DNL_stdev = sqrt(var(obj.DNL));
            %get_Energy_code(obj, 128)
        end

        function y = eval(obj, Vin)
            if Vin == 0
                Vout = 0;
            elseif Vin == 256
                Vout = 1;
            else
                Vout = obj.Vouts(Vin);
            end
            y = Vout;
        end
    end
end

function y = get_Vouts(obj)

    buff = zeros(8,8);
    Vout = [obj.Ctup/(obj.Ctup + obj.Ctdown)];

    for i = 2:8
        for j = 1:2^(i-1)
            code = de2bi(j-1,i-1,'left-msb');
            Cup = sum(obj.Carray(1:i-1,1:i-1)*code') + obj.Ctup;
            Ctot = sum(sum(obj.Carray(1:i-1,1:i-1))) + (obj.Ctup + obj.Ctdown);
            Vout = [Vout Cup/Ctot];
        end
    end

    Vout = sort(Vout);
    y = Vout;
end

function y = add_mismatch(u)
    buff = u;
    Cap = 1e-15;
    Cu = 1*Cap;
    sigma_Cu = 0.005;

    sigma = Cu*buff*sigma_Cu/sqrt(buff);
    buff = normrnd(Cu*buff,sigma);
    y = buff;
end

function y = get_Energy_code(obj, Vin)
    
    Etotal = 0;
    Vref = 1;
    Vup = 256;
    Vdown = 0;
    code = zeros(1,7);
    if Vin >= (Vup+Vdown)/2
       Vdown = (Vup+Vdown)/2;       
       code(1) = 1;
    else 
       Vup = (Vup+Vdown)/2;
       code(1) = 0;
    end
        
    Vi = zeros(7,7);
    Vf = zeros(7,7);
    for i = 1:7
        if Vin >= (Vup+Vdown)/2
           Vdown = (Vup+Vdown)/2;
           code(i) = 1; 
        else 
           Vup = (Vup+Vdown)/2;
           code(i) = 0; 
        end 
        Vx = obj.eval((Vup+Vdown)/2);
        for k = 1:i
            for l = 1:i
                if code(l) == 1
                    Vf(k,l) = Vx - Vref;
                else
                    Vf(k,l) = Vx;
                end
            end
        end
       
        Ecycle = -Vref*sum(sum((obj.Carray.*(Vf-Vi))));
        Etotal = Etotal + Ecycle;

        Vi = Vf;
    end
    Etotal
    y = Etotal;
end

