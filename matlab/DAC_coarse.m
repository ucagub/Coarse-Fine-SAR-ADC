classdef DAC_coarse
    properties (Access = public)
        type
        Vref
        DNL;
        %abs_max_DNL
        %DNL_stdev
        %value
    end
    properties (Access = private)
        Cupm
        Cdownm
    end
    methods
        function obj = DAC_coarse(name)
            obj.type = name;
            obj.Vref = 1;
            %obj.value = randsd(1);
            [obj.Cupm , obj.Cdownm] = init_mismatch();
            obj.DNL = get_DNL_coarse(obj);
            %obj.abs_max_DNL = max(abs(obj.DNL));
            %obj.DNL_stdev = get_DNL_stdev()
        end

        function y = eval(obj, Vin)
            [code_up, code_down] = getCode_coarse(Vin);
            Vout = obj.Vref*(code_up*obj.Cupm' + code_down*obj.Cdownm')/sum(obj.Cupm+obj.Cdownm);
            y = Vout;
        end

    end
end

function [y, z] = init_mismatch()
    %initializes mismatch in caps
    Cap = 1e-15;
    Cu = 1*Cap;
    sigma_Cu = 0.05;
    
    resolution = 4;
    LSB = 1/2^resolution;
    Cup = [2^2 2^1 2^0 1];
    Cdown = [2^2 2^1 2^0 1];
    Carray = [Cup Cdown];
    
    %initialize Cupm Cdownm
    Cupm = Cup;
    Cdownm = Cdown;
    
    for a = 1:resolution
        sigma = Cu*Cup(a)*sigma_Cu/sqrt(Cup(a));
        Cupm(a) = normrnd(Cu*Cup(a),sigma);
    end
    for a = 1:resolution
        sigma = Cu*Cdown(a)*sigma_Cu/sqrt(Cdown(a));
        Cdownm(a) = normrnd(Cu*Cdown(a),sigma);
    end
    y = Cupm;
    z = Cdownm;
end 

function [y, z] = getCode_coarse(u)
    %sets the cap arrangement for cap split
    Vin = (u);
    %Vref = obj.Vref;
    Vref = 1;
    Vup = 16;
    Vdown = 0;
    code_up = [1 1 1 1];
    code_down = [0 0 0 0];
    for i = 1:4
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
