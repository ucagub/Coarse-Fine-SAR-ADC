classdef DAC2 < mother_DAC
    properties (Access = public)
        DNL
        INL
        Epercycle
        %abs_max_DNL
        %DNL_stdev
        %value
        Cupm
        Cdownm
        skip_bits
        Vouts
    end
    properties (Access = private)
%         Cupm
%         Cdownm
    end
    methods
        function obj = DAC2(N, varargin)
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
            %obj.value = randsd(1);
            [obj.Cupm , obj.Cdownm] = init_mismatch(obj);
            obj.Vouts = obj.get_Vouts();
%             obj.DNL = get_DNL(obj);
%             obj.INL = get_INL(obj);
            %obj.abs_max_DNL = max(abs(obj.DNL));
            %obj.DNL_stdev = get_DNL_stdev()
%             obj.Epercycle = get_Epercycle(obj);
        end
        function y = eval(obj, Vin)
            N = obj.res;
            if Vin == 0
                y = 0;
            elseif Vin == 2^N
                y = obj.Vref;
            else
                y = obj.Vouts(Vin);
            end
        end
        function y = evals(obj, Vin)
            [code_up, code_down] = getCode(obj, Vin);
            Vout = obj.Vref*(code_up*obj.Cupm' + code_down*obj.Cdownm')/sum(obj.Cupm+obj.Cdownm + obj.load_cap);
            y = Vout - obj.droop;
        end
        function Vouts = get_Vouts(obj)
            N = obj.res; 
            buff = zeros(1,2^N-1);
            for i = 1:2^N-1
                buff(i) = obj.evals(i);
            end
            
            Vouts = buff;
        end
        function y = disp_Epercycle(obj)
            if isempty(obj.Epercycle) 
                obj.Epercycle = get_Epercycle(obj);
                y = obj.Epercycle;
            else
                y = obj.Epercycle;
            end
        end
    end
end

function [y, z] = init_mismatch(obj)
    %initializes mismatch in caps
   
    N = obj.res;
    
    %initialize Cupm Cdownm
    Cupm = [1];
    Cdownm = [1];
    for i = 1:N-1
        Cupm = [2^(i-1) Cupm];
        Cdownm = [2^(i-1) Cdownm];
    end

    
    
    %add mismatch to caps
    for i = 1:length(Cupm)
        Cupm(i) = add_mismatch(obj, Cupm(i)); 
        Cdownm(i) = add_mismatch(obj, Cdownm(i));
    end
%     Cupm = arrayfun(@add_mismatch, Cupm);
%     Cdownm = arrayfun(@add_mismatch, Cdownm);
    y = Cupm;
    z = Cdownm;
end 

function y = add_mismatch(obj, u)
    %add mismatch to cap u
%     sigma_Cu = obj.mismatch;
    sigma_Cu = 0;
    buff = u;
    Cap = obj.Cu;
    Cu = 1*Cap;
    
    sigma = Cu*buff*sigma_Cu/sqrt(buff);
    buff = normrnd(Cu*buff,sigma);
    y = buff;
end

function [y, z] = getCode(obj, u)
    %sets the cap arrangement for cap split
    N = obj.res;
    Vin = (u);
    %Vref = obj.Vref;
    Vref = 1;
    Vup = 2^N;
    Vdown = 0;
    code_up = zeros(1,N) + 1;
    code_down = zeros(1,N);
    for i = 1:N
        if Vin > (Vup+Vdown)/2
           Vdown = (Vup+Vdown)/2;
           code_down(i) = 1;
        elseif Vin < (Vup+Vdown)/2
           Vup = (Vup+Vdown)/2;
           code_up(i) = 0;
        else
            break;
        end 
    end
    y = code_up;
    z = code_down;
end

function y = get_DNL_stdev()
    iter = 1000;
    buff = zeros(iter, 255);
    
    for i = 1:iter
        a = DAC('asfd');
        buff(i,:) = a.DNL;
    end
    
    code_var = zeros(1,255)
    for i = 1:255
        code_var(i) = var(buff(:,i));
    end
    code_stdev = sqrt(code_var);
    y = code_stdev;
end

function y = CS_pow(obj, u)
%input : code in decimal format
%output : energy for the input code
%     Cup = [2^6 2^5 2^4 2^3 2^2 2^1 2^0 1];
%     Cdown = [2^6 2^5 2^4 2^3 2^2 2^1 2^0 1];
    N = obj.res;
    Cup = obj.Cupm;
    Cdown = obj.Cdownm;
    Carray = [Cup Cdown];

    Vref = 1;
    Vup = 2^N;
    Vdown = 0;
    Vin = (u);
    code_up = zeros(1,N) + 1;
    code_down = zeros(1,N);


    Vi = zeros(1,N*2);
    Etotal = 0;
    %code_cycle = [];
    %code_prev = zeros(1,16);
    for i = 1:N-1
        Vout = Vref*(code_up*Cup' + code_down*Cdown')/sum(Cup+Cdown);
        %code_cycle = [code_cycle (Vup+Vdown)/2];

        Vcap_up = Vout - code_up*Vref;
        Vcap_down = Vout - code_down*Vref;
        Vf = [Vcap_up Vcap_down];
        Ecycle = -Vref*(Carray*((Vf-Vi).*[code_up code_down])');
        Etotal = Etotal + Ecycle;

        Vi = Vf;
        if Vin >= (Vup+Vdown)/2
           Vdown = (Vup+Vdown)/2;
           code_down(i) = 1;
        else 
           Vup = (Vup+Vdown)/2;
           code_up(i) = 0;
        end 
    end

    %Vout = Vref*(code_up*Cup' + code_down*Cdown')/(2^8);
    y = Etotal;
end

function y = CS_pow_skip(obj, u)
    %input : code in decimal format
    %output : energy for the input code
    N = obj.res;
    Cup = obj.Cupm;
    Cdown = obj.Cdownm;
    Carray = [Cup Cdown];

    Vref = 1;
    Vup = 2^N;
    Vdown = 0;
    Vin = u;
    code_up = zeros(1,N) + 1;
    code_down = zeros(1,N);
    [code_up code_down] = get_skip_code(obj, Vin);

    Vi = zeros(1,N*2);
    Etotal = 0;
    %code_cycle = [];
    %code_prev = zeros(1,16);
    for i = 1:N-1
        Vout = Vref*(code_up*Cup' + code_down*Cdown')/sum(Cup+Cdown);
        %code_cycle = [code_cycle (Vup+Vdown)/2];

        Vcap_up = Vout - code_up*Vref;
        Vcap_down = Vout - code_down*Vref;
        Vf = [Vcap_up Vcap_down];
        Ecycle = -Vref*(Carray*((Vf-Vi).*[code_up code_down])');
        Etotal = Etotal + Ecycle;

        Vi = Vf;
        if Vin >= (Vup+Vdown)/2
           Vdown = (Vup+Vdown)/2;
           code_down(i) = 1;
        else 
           Vup = (Vup+Vdown)/2;
           code_up(i) = 0;
        end 
    end

    %Vout = Vref*(code_up*Cup' + code_down*Cdown')/(2^8);
    y = Etotal;
end

function [c_up, c_down] = get_skip_code(obj, Vin)
    %inputs : number of skipped bits (skip_bits)
    %       : Vin in decimal format
    %returns: the Carray code configuration
    N = obj.res;
    Vup = 2^N;
    Vdown = 0;
    code_up = zeros(1,N) + 1;
    code_down = zeros(1,N);
    for i = 1:obj.skip_bits
        if Vin >= (Vup+Vdown)/2
           Vdown = (Vup+Vdown)/2;
           code_down(i) = 1;
        else 
           Vup = (Vup+Vdown)/2;
           code_up(i) = 0;
        end 
    end
    c_up = code_up;
    c_down = code_down;
    
end

function y = get_Epercycle(obj)
    N = obj.res;
    energy = zeros(1,2^N-1);
    if not(isempty(obj.skip_bits))
        pow = @CS_pow_skip;
    else
        pow = @CS_pow;
    end
    for i = 0:2^N-1
        energy(i+1) = pow(obj, i);
    end
    y = energy;
end
