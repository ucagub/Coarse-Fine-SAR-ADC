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
                          2 2 4 0 0 0 0;
                          2 2 4 8 0 0 0; 
                          2 2 4 8 16 0 0; 
                          2 2 4 8 16 32 0; 
                          2 2 4 8 16 32 64];
%             obj.Ctup = add_mismatch(obj.Ctup);
%             obj.Ctdown = add_mismatch(obj.Ctdown);
%             
%             for a = 1:7
%                 for b = 1:a
%                     obj.Carray(a,b) = add_mismatch(obj.Carray(a,b));
%                 end
%             end
            obj.Vouts = get_Vouts(obj);
            obj.DNL = get_DNL(obj);
            obj.INL = get_INL(obj);
            %obj.abs_max_DNL = max(abs(obj.DNL));
            %obj.DNL_stdev = sqrt(var(obj.DNL));
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
    methods(Access = private)
        function init_mismatch(obj)
            obj.Ctdown = 2;
            %Cap = 1e-6;
            Cap = 1;
            Cu = 1*Cap;
            sigma_Cu = 0.05;

            sigma = Cu*obj.Ctup*sigma_Cu/sqrt(obj.Ctup);
            obj.Ctup = normrnd(Cu*obj.Ctup,sigma);

            sigma = Cu*obj.Ctdown*sigma_Cu/sqrt(obj.Ctdown);
            obj.Ctdown = normrnd(Cu*obj.Ctdown,sigma);

            for a = 1:7
                for b = 1:7
                    sigma = Cu*obj.Carray(a,b)*sigma_Cu/sqrt(obj.Carray(a,b));
                    obj.Carray(a,b) = normrnd(Cu*obj.Carray(a,b),sigma);
                end
            end
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
            Ctot = sum(sum(obj.Carray(1:i-1,1:i-1))) + (obj.Ctup + obj.Ctdown)
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

