classdef Conv_DAC < mother_DAC
    properties (Access = public)
        DNL
        INL
        Carray
        skip_bits
        Epercycle
    end
    properties (Access = private)
        %Cupm
        %Cdownm
    end
    methods
        function obj = Conv_DAC(N, varargin)
            %(resolution, Cu, skip_bits, load_cap, droop )
            load_cap = 0;
            skip_bits = [];
            droop = 0;
            switch nargin
                case 1
                    Cu = 'Default';
                case 2
                    Cu = varargin{1};
                case 3
                    Cu = varargin{1};
                    skip_bits = varargin{2};
                case 4
                    Cu = varargin{1};
                    skip_bits = varargin{2};
                    load_cap = varargin{3};
                case 5
                    Cu = varargin{1};
                    skip_bits = varargin{2};
                    load_cap = varargin{3};
                    droop = varargin{4};
            end
            obj@mother_DAC(N, Cu, 'CS_DAC', load_cap, droop);
            obj.skip_bits = skip_bits; 
            obj.Carray = [1 2.^[0:obj.res-1]];
            
            for i = 1:obj.res+1
                obj.Carray(i) = obj.add_mismatch(obj.Carray(i)); 
            end
            obj.Epercycle = obj.get_Epercycle()
            obj.DNL = get_DNL(obj);
            obj.INL = get_INL(obj);
        end

        function y = eval(obj, Vin)
            inCode = de2bi(Vin,obj.res);
            Vout = obj.Vref*(obj.Carray*[0 inCode]')/sum(obj.Carray);
            y = Vout;
        end
        function y = get_Epercycle(obj)
            N = obj.res;
            Vinit = zeros(1,N);
            Eper = zeros(1, 2^N-1);
            for i = 1:2^N-1
                codes = obj.getCode(i);
                Etotal = 0;
                for j = 1:N
                    config = de2bi(codes(j), N);
                    Vfinal = -obj.Vref.*config + (zeros(1,N) + obj.eval(codes(j)));
                    sum(-obj.Vref*obj.Carray(2:end).*(Vfinal-Vinit).*config)
                    Etotal = Etotal + sum(-obj.Vref*obj.Carray(2:end).*(Vfinal-Vinit).*config);
                end
                Eper(i) = Etotal;
            end
            y = Eper;
        end
        function y = getCode(obj, u)
            %sets the cap arrangement for cap split
            N = obj.res;
            Vin = u;
            Vref = obj.Vref;
            Vup = 2^N;
            Vdown = 0;
            codes = zeros(1,N);
            for i = 1:N
                codes(i) = (Vup+Vdown)/2;
                if Vin >= (Vup+Vdown)/2
                   Vdown = (Vup+Vdown)/2;
                else
                   Vup = (Vup+Vdown)/2;
                end 
            end
            y = codes;
        end
        function y = add_mismatch(obj, u)
            buff = u;
            Cap = obj.Cu;
            Cu = 1*Cap;
            sigma_Cu = obj.mismatch;

            sigma = Cu*buff*sigma_Cu/sqrt(buff);
            buff = normrnd(Cu*buff,sigma);
            y = buff;
        end

    end
end

