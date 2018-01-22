classdef Conv_DAC
    properties (Access = public)
        type
        Vref
        DNL
        Carray
        %abs_max_DNL
        %DNL_stdev
        %value
    end
    properties (Access = private)
        %Cupm
        %Cdownm
    end
    methods
        function obj = Conv_DAC(name)
            obj.type = name;
            obj.Vref = 1;
            obj.Carray = [1 2^0 2^1 2^2 2^3 2^4 2^5 2^6 2^7];
            for i = 1:9
                obj.Carray(i) = add_mismatch(obj.Carray(i)); 
            end
            obj.DNL = get_DNL(obj);
            %obj.abs_max_DNL = max(abs(obj.DNL));
            %obj.DNL_stdev = get_DNL_stdev()
        end

        function y = eval(obj, Vin)
            inCode = de2bi(Vin,8);
            Vout = obj.Vref*(obj.Carray*[0 inCode]')/sum(obj.Carray);
            y = Vout;
        end

    end
end

function y = add_mismatch(u)
    buff = u;
    Cap = 1e-15;
    Cu = 1*Cap;
    sigma_Cu = 0.05;

    sigma = Cu*buff*sigma_Cu/sqrt(buff);
    buff = normrnd(Cu*buff,sigma);
    y = buff;
end