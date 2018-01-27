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
        Epercycle
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
            
            %add mismatch to every cap in obj.Carray
            for a = 1:7
                for b = 1:a
                    obj.Carray(a,b) = add_mismatch(obj.Carray(a,b));
                end
            end
            
            %get every possible output of the DAC, store as array in
            %obj.Vouts
            obj.Vouts = get_Vouts(obj);
            
            %generate INL and DNL
            obj.DNL = get_DNL(obj);
            obj.INL = get_INL(obj);
            
            %get energy per code
            obj.Epercycle = get_Epercycle(obj);
            
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
        
        function Ecode = get_Ecode(obj, Vin)
            Ecode = get_Ecycle1(obj, Vin);
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

function y = get_Epercycle(obj)
    %returns the energy required to search for every possible quantization 
    %of input Vin for the SAR ADC
    Epercycle = zeros(1,255);
    for i = 1:255
        Epercycle(i) = get_Ecycle1(obj, i);
    end
    y = Epercycle;
end

function Ecycle = get_Ecycle1(obj, Vin)
    %returns the total energy after 8 cycles to search for Vin
    Varray_init = zeros(7,7);
    Etotal = 0;
    Vref = 1;
    codeCycle = get_codeCycle(Vin);
    Vter_i = Vref*obj.Ctup/(obj.Ctup + obj.Ctdown) - Vref;
    
    for i = 2:8
        code = codeCycle(i);
        config = de2bi(code,8,'left-msb');
        %Vter is for the termination cap
        %energy for the termination cap
        Vx = obj.eval(code);
        Vter_f = Vx - Vref;
        Eter  = -Vref*obj.Ctup*(Vter_f - Vter_i);
        Vter_i = Vter_f;
        
        %energy for the rest of the Carray
        Varray_final = get_Varray(obj, code, i);
        
        dV = Varray_final-Varray_init;
        %Varray_final = get_Varray(obj, i);
        CV_array = (obj.Carray.*(dV));
        CV_array = CV_array(1:i-1, 1:i-1);
        config = config(1:i-1);
        buff_array = -Vref*(CV_array.*config);
        Etran = sum(sum(buff_array));
        Etotal = Etotal + Etran + Eter; 
        Varray_init = Varray_final;
    end
    
    %energy contribution of the termination cap
    
    
    Ecycle = Etotal;
end

function Varray_final = get_Varray(obj, code, stage_num)
    %returns the voltage for each cap at the given output code
    Vref = 1;
    Varray_buff = zeros(stage_num-1,stage_num-1);
    config = de2bi(code,8,'left-msb');
    %config
    Vx = obj.eval(code);
    
    V1d = (Vx - Vref*config);
    for i = 1:stage_num-1
        Varray_buff(:,i) = V1d(i);
    end
    Varray_final = padarray(Varray_buff, [8-stage_num, 8-stage_num], 'post');
    
end

function codeCycle = get_codeCycle(Vin)
    %returns the sequence of codes in the binary search
    Vup = 256;
    Vdown = 0;
    
    code_buff = [128];
    for i = 1:7
        if Vin >= (Vup+Vdown)/2
           Vdown = (Vup+Vdown)/2;
           code_buff = [code_buff (Vup+Vdown)/2];
        else
           Vup = (Vup+Vdown)/2;
           code_buff = [code_buff (Vup+Vdown)/2];
        end 
    end
    codeCycle = code_buff;
end
