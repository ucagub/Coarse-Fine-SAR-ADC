classdef TSJS_DAC < mother_DAC
    properties (Access = public)
       
        DNL
        INL
        Epercycle
        Emean
        Cupm
        Cdownm
        
        skip_bits
        Vouts
    end
    methods
        function obj = TSJS_DAC(N, varargin)
            %(resolution, Cu, skip_bits )
            switch nargin
                case 1
                    skip_bits = [];
                    Cu = 'Default';
                case 2
                    skip_bits = [];
                    Cu = varargin{1};
                case 3
                    Cu = varargin{1};
                    skip_bits = varargin{2};
            end
            obj@mother_DAC(N, Cu, 'TSJS_DAC');
            obj.skip_bits = skip_bits;

            
            buff = [2 0 0 0 0 0 0; 
                    2 2 0 0 0 0 0; 
                    4 2 2 0 0 0 0;
                    8 4 2 2 0 0 0; 
                    16 8 4 2 2 0 0; 
                    32 16 8 4 2 2 0; 
                    64 32 16 8 4 2 2];
            obj.Cupm.Carray = buff(1:ceil((N-2)/2),1:ceil((N-2)/2));
            obj.Cupm.Cter_r = 1;
            obj.Cupm.Cter_l = 1;
            
            obj.Cdownm.Carray = buff(1:ceil((N-2)/2),1:ceil((N-2)/2));
            obj.Cdownm.Cter_r = 1;
            obj.Cdownm.Cter_l = 1;
            
            %add mismatch to the caps         
            obj.init_mismatch();
            
            obj.Vouts = obj.get_Vouts();
%             obj.DNL = get_DNL(obj);
%             obj.INL = get_INL(obj);
%             obj.Epercycle = obj.get_Epercycle();
%             obj.Emean = mean(obj.Epercycle);
            %get_codeCycle(obj, 128)
            
        end
        function y = eval(obj, Vin)
            N = obj.res;
            N_t = ceil(obj.res/2)*2;
            if N/2 < ceil(N/2)
                Vin = Vin*2;
            end
            %Vin 
            if Vin == 0
                Vout = 0;
            elseif Vin == 2^N_t
                Vout = 1;
            else
                Vout = obj.Vouts(Vin);
            end
            y = Vout;
        end
        function y = getE(obj, Vin)
            y = obj.get_Ecycle1(Vin);
        end
    end
    methods (Access = public)
        function y = add_mismatch(obj, u)
            %adds mismatch to each cap
            buff = u;
            Cap = obj.Cu;
            Cu = 1*Cap;
            sigma_Cu = obj.mismatch;
            
            %skip if u = 0
            if u == 0
                y = 0;
                return
            end

            sigma = Cu*buff*sigma_Cu/sqrt(buff);
            buff = normrnd(Cu*buff,sigma);
            y = buff;
        end
        function y = get_Vouts(obj)
            %disp('-----------------------------------------------------------')
            N = obj.res;
            N_t = ceil(obj.res/2)*2;
            k = ceil(N/2); %coarse res
            %buff = zeros(N,N);
            Vout = zeros(1,2^(2*k)-1);
            Vout(2^N_t/2) = obj.Vref*obj.Cupm.Cter_r/(obj.Cupm.Cter_l + obj.Cupm.Cter_r);
            
            
            for i = 2:k
                for j = 1:2^(i-1)
                    %coarse stage
                    code = de2bi(j-1,i-1,'left-msb');
                    Cup = sum(obj.Cupm.Carray(1:i-1,1:i-1)*code') + obj.Cupm.Cter_l;
                    Ctot = sum(sum(obj.Cupm.Carray(1:i-1,1:i-1))) + (obj.Cupm.Cter_l + obj.Cupm.Cter_r);
                    %index = (2^N)*(j*2-1)/2^i;
                    Vout((2^N_t)*(j*2-1)/2^i) = obj.Vref*Cup/Ctot;
                end
            end
            
            %fine stage
            
            for w = 1:2^(k-1)
                
                for p = 0:1
                    index = (2^N_t)*(((p+1)*2-1 + (w-1)*4)/2^(k+1));
                    if (k-1) == 0
                        code = -1;
                    else
                        code = de2bi(w-1,k-1,'left-msb');
                    end
                    
                    if p == 1
                        Vup_bound = obj.get_Vup_bound(code);
                        Vlow_bound = Vout((w-1)*2^(k+1) + 2^k);
                        Vout(index) = (obj.Cupm.Cter_r*Vup_bound + obj.Cdownm.Cter_r*Vlow_bound)/(obj.Cupm.Cter_r + obj.Cdownm.Cter_r);
                    elseif p == 0
                        Vup_bound = Vout((w-1)*2^(k+1) + 2^k);
                        Vlow_bound = obj.get_Vlow_bound(code);
                        Vout(index) = (obj.Cupm.Cter_r*(Vup_bound-obj.Vref) + obj.Cdownm.Cter_r*Vlow_bound + obj.Cupm.Cter_r*obj.Vref)/(obj.Cupm.Cter_r + obj.Cdownm.Cter_r);
                    end
                    dV = Vup_bound - Vlow_bound;
                    Vdown = Vlow_bound;
                    for stage = 1:k-1
                        for m = 1:2^stage
                            code = de2bi(m-1,stage,'left-msb');
                            buff_up = obj.Cupm.Carray;
                            buff_down = obj.Cdownm.Carray;
                            
                            Cup = sum(buff_up(1:stage, 1:stage)*code') + obj.Cupm.Cter_r;
                            Cdown = sum(buff_down(1:stage, 1:stage)*not(code)') + obj.Cdownm.Cter_r;

                            Vf = dV*(Cup)/(Cup + Cdown) + Vdown;

                            %find the index
                            
                            index = (w-1)*2^(k+1) + (1+2*(m-1))*2^(k-1)/2^(stage) + p*2^(k);
                            Vout(index) = Vf;
                        end
                    end
                end
            end
            y = Vout;
        end
        function Vup_bound = get_Vup_bound(obj, code)
            %set Cupm as the upper bound array
            %code
            N = obj.res;
            i = ceil(N/2);
            if code == -1
                Cup = (obj.Cupm.Cter_l + obj.Cupm.Cter_r);
                Ctot = Cup;
            else
                Cup = sum(obj.Cupm.Carray(1:i-1,1:i-1)*code') + (obj.Cupm.Cter_l + obj.Cupm.Cter_r);
                Ctot = sum(sum(obj.Cupm.Carray(1:i-1,1:i-1))) + (obj.Cupm.Cter_l + obj.Cupm.Cter_r);
            end
            
            Vup_bound = obj.Vref*Cup/Ctot;
        end
        function Vlow_bound = get_Vlow_bound(obj, code)
            %set Cdownm as the lower bound array
            N = obj.res;
            i = ceil(N/2);
            if code == -1
                Cup = 0;
                Ctot = (obj.Cdownm.Cter_l + obj.Cdownm.Cter_r);
            else
                Cup = sum(obj.Cdownm.Carray(1:i-1,1:i-1)*code');
                Ctot = sum(sum(obj.Cdownm.Carray(1:i-1,1:i-1))) + (obj.Cdownm.Cter_l + obj.Cdownm.Cter_r);
            end
            
            Vlow_bound = obj.Vref*Cup/Ctot;
        end
        
        function Varray_final = get_Varray(obj, code, stage_num)
            %returns the voltage for each cap at the given decimal output code
            N = obj.res;
            Vref = obj.Vref;
            k = ceil(N/2);
            Varray_buff = zeros(stage_num-1,stage_num-1);
            
            config = de2bi(code,N,'left-msb');
            config = config(1:stage_num-1);
            %config
            Vx = obj.eval(code);

            V1d = (Vx - Vref*config);
            for i = 1:stage_num-1
                Varray_buff(:,i) = V1d(i);
            end
            Varray_buff = Varray_buff.*tril(ones(stage_num-1,stage_num-1));
            Varray_final = padarray(Varray_buff, [k-stage_num, k-stage_num], 'post');
            
        end
        
        function Varray_final = get_Varray_tran(obj, code, Vx)
            %returns the voltage for each cap at the transition decimal output code
            N = obj.res;
            Vref = obj.Vref;
            k = ceil(N/2);
            
            Varray_buff = zeros(k-1,k-1);
            
            config = de2bi(code,N,'left-msb');
            config = config(1:k-1);
            %config
            %Vx = obj.eval(code);
            %Vx
            V1d = (Vx - Vref*config);
            for i = 1:k-1
                Varray_buff(:,i) = V1d(i);
            end
            Varray_buff = Varray_buff.*tril(ones(k-1,k-1));
            Varray_final = Varray_buff;
            
        end
        function init_mismatch(obj)
            obj.Cupm.Carray = arrayfun(@obj.add_mismatch, obj.Cupm.Carray);
            obj.Cupm.Cter_r = obj.add_mismatch(obj.Cupm.Cter_r);
            obj.Cupm.Cter_l = obj.add_mismatch(obj.Cupm.Cter_l);
            
            obj.Cdownm.Carray = arrayfun(@obj.add_mismatch, obj.Cdownm.Carray);
            obj.Cdownm.Cter_r = obj.add_mismatch(obj.Cdownm.Cter_r);
            obj.Cdownm.Cter_l = obj.add_mismatch(obj.Cdownm.Cter_l);
        end
        function codeCycle = get_codeCycle(obj, Vin)
            %returns the sequence of codes in the binary search 
            %inputs : code Vin 
            N = obj.res;
            Vup = 2^N;
            Vdown = 0;

            code_buff = [2^(N-1)];
            for i = 1:N-1
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
        function Ecycle = get_Ecycle1(obj, Vin)
            %returns the total energy after 8 cycles to search for Vin
            
            N = obj.res;
            k = ceil(N/2);
            N_t = 2*k;
            Varray_init = zeros(k-1,k-1);
            Etotal = 0;
            Vref = obj.Vref;
            codeCycle = obj.get_codeCycle(Vin);
            Vter_i = Vref*obj.Cupm.Cter_l/(obj.Cupm.Cter_l + obj.Cupm.Cter_r) - Vref;
            %coarse stage
            %assuming Vout of obj.Cupm.Carray == obj.Cdownm.Carray 
            for i = 2:k
                code = codeCycle(i);
                config = de2bi(code,N,'left-msb');
                config = config(1:i-1);
                %Vter is for the termination cap
                %energy for the termination cap
                Vx = obj.eval(code);
                Vter_f = Vx - Vref;
                Eter  = -Vref*(obj.Cupm.Cter_l+obj.Cdownm.Cter_l)*(Vter_f - Vter_i);
                Vter_i = Vter_f;

                %energy for the rest of the Carray
                Varray_final = get_Varray(obj, code, i);

                dV = Varray_final-Varray_init;
                
                CV_array = ((obj.Cupm.Carray + obj.Cdownm.Carray).*(dV));
                CV_array = CV_array(1:i-1, 1:i-1);
                buff_array = -Vref*(CV_array.*config);
                Etran = sum(sum(buff_array));
                Etotal = Etotal + Etran + Eter; 
                Varray_init = Varray_final;
            end

            %fine stage
            code = codeCycle(k);
            config = de2bi(code,N,'left-msb');
            p = config(k);
            config = config(1:k-1);
%             Varray_init = obj.eval(code);
            
            
            
            if p == 1
                
                Vup_bound = obj.get_Vup_bound(config);
                %Vup_bound
                Vlow_bound = obj.eval(code);
                Vter_f = Vup_bound;
                Vter_i = Vlow_bound;
                Eter  = -Vref*obj.Cupm.Cter_l*(Vter_f - Vter_i);
                Varray_final = get_Varray_tran(obj, code, Vup_bound);
                dV = Varray_final-Varray_init;
                CV_array = obj.Cupm.Carray.*(dV);
                Vter_i = Vup_bound;
            elseif p == 0
                Vup_bound = obj.eval(code);
                Vlow_bound = obj.get_Vlow_bound(code);
                Vter_f = Vlow_bound;
                Vter_i = Vup_bound;
                Eter  = -Vref*obj.Cdownm.Cter_l*(Vter_f - Vter_i);
                Varray_final = get_Varray_tran(obj, code, Vlow_bound);
                dV = Varray_final-Varray_init;
                CV_array = obj.Cdownm.Carray.*(dV);
            end
            
            CV_array = CV_array(1:i-1, 1:i-1);
            buff_array = -Vref*(CV_array.*config);
            Etran = sum(sum(buff_array));
            Etotal = Etotal + Etran + Eter; 
            
            
            if p == 1
                code = codeCycle(k+1);
                Vter_f = obj.eval(code) - Vref;
                Eter  = -Vref*obj.Cdownm.Cter_l*(Vter_f - Vter_i);
                Etotal = Etotal + Eter;
                Vter_i = Vter_f; 
            end
            
            Varray_init_up = obj.get_Varray_tran(code, Vup_bound);
            Varray_init_down = obj.get_Varray_tran(code, Vlow_bound);
            %disp('---init---')
            Varray_final_up = obj.get_Varray_tran(code, Vup_bound);
            Varray_final_down = obj.get_Varray_tran(code, Vlow_bound);
            
            for i = 2:N-k
                code = codeCycle(i+k);
                Vx = obj.eval(code);
                %Vter is for the termination cap
                %energy for the termination cap

%                 if i ==2
%                     disp('start')
%                 end
                top_plate_config_up = de2bi(code, N, 'left-msb');
                top_plate_config_up = top_plate_config_up(k+1:k+i-1);
                top_plate_config_up = [top_plate_config_up zeros(1,N_t - (k+i))];
                top_plate_config_down = not(top_plate_config_up) + 0;
                if p == 1
                    Vter_f = Vx - Vref;
                    Eter  = -Vref*(obj.Cupm.Cter_r)*(Vter_f - Vter_i);
                    Vter_i = Vter_f;
                else
                    Eter = 0;
                end

%                 energy for the rest of the Carray up
                Varray_buff_up = obj.get_Varray_tran(code, Vx).*top_plate_config_up;
                Varray_final_up(1:i-1, 1:i-1) = Varray_buff_up(1:i-1, 1:i-1);
                dV_up = Varray_final_up-Varray_init_up;
                
                CV_array_up = obj.Cupm.Carray.*(dV_up);
                CV_array_up = CV_array_up(1:k-1, 1:k-1);
                buff_array_up = -Vref*(CV_array_up.*top_plate_config_up);
                Etran_up = sum(sum(buff_array_up));
                
%                 down Carray
                Varray_buff_down = obj.get_Varray_tran(code, Vx).*top_plate_config_down;
                Varray_final_down(1:i-1, 1:i-1) = Varray_buff_down(1:i-1, 1:i-1);
                dV_down = Varray_final_down-Varray_init_down;
                
                CV_array_down = obj.Cdownm.Carray.*(dV_down);
                CV_array_down = CV_array_down(1:k-1, 1:k-1);
                buff_array_down = -Vref*(CV_array_down.*top_plate_config_down);
                Etran_down = sum(sum(buff_array_down));
                
                
                Etotal = Etotal + Etran_up + Etran_down + Eter; 
                Varray_init_up = Varray_final_up;
                Varray_init_down = Varray_final_down;
            end
            %Vin
            Ecycle = Etotal;
        end
        function y = get_Epercycle(obj)
            %returns the energy required to search for every possible quantization 
            %of input Vin for the SAR ADC
            N = obj.res;
            k = ceil(N/2);
            Epercycle = zeros(1,2^N-1);
            if not(isempty(obj.skip_bits))
                pow = @get_Ecycle1_skip;
            else
                pow = @get_Ecycle1;
            end
            for i = 1:2^N-1
                Epercycle(i) = pow(obj, i);
            end
            y = Epercycle;
        end
        
    end
end