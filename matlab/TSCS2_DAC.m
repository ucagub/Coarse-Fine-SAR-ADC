classdef TSCS2_DAC < mother_DAC
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
    methods (Access = public )
        function obj = TSCS2_DAC(N, varargin)
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
            obj@mother_DAC(N, Cu, 'TSCS2_DAC');
            obj.skip_bits = skip_bits;
            
            buff = [2 0 0 0 0 0 0; 
                    2 2 0 0 0 0 0; 
                    4 2 2 0 0 0 0;
                    8 4 2 2 0 0 0; 
                    16 8 4 2 2 0 0; 
                    32 16 8 4 2 2 0; 
                    64 32 16 8 4 2 2];
%             obj.Cupm.Carray = buff(1:ceil((N-2)/2),1:ceil((N-2)/2));
%             obj.Cupm.Cter_r = 1;
%             obj.Cupm.Cter_l = 1;
%             
%             obj.Cdownm.Carray = buff(1:ceil((N-2)/2),1:ceil((N-2)/2));
%             obj.Cdownm.Cter_r = 1;
%             obj.Cdownm.Cter_l = 1;
            buff_Cupm_Carray = buff(1:ceil((N-2)/2),1:ceil((N-2)/2));
            buff_Cupm_Cter_r = 1;
            buff_Cupm_Cter_l = 1;
            buff_bigup_cap = [2.^[ceil((N-2)/2)-1:-1:0] 1];
            
            buff_Cdownm_Carray = buff(1:ceil((N-2)/2),1:ceil((N-2)/2));
            buff_Cdownm_Cter_r = 1;
            buff_Cdownm_Cter_l = 1;
            buff_bigdown_cap = [2.^[ceil((N-2)/2)-1:-1:0] 1];
            
            %add mismatch to the caps         
            for i = 1:size(buff_Cupm_Carray,1)
                for j = 1:size(buff_Cupm_Carray,2)
                    buff_Cupm_Carray(i,j) = obj.add_mismatch(buff_Cupm_Carray(i,j));
                end
            end
            
            buff_Cupm_Cter_r = obj.add_mismatch(buff_Cupm_Cter_r);
            buff_Cupm_Cter_l = obj.add_mismatch(buff_Cupm_Cter_l);
            
            for i = 1:length(buff_bigup_cap)
                buff_bigup_cap(i) = obj.add_mismatch(buff_bigup_cap(i));
            end
            
            for i = 1:size(buff_Cdownm_Carray,1)
                for j = 1:size(buff_Cdownm_Carray,2)
                    buff_Cdownm_Carray(i,j) = obj.add_mismatch(buff_Cdownm_Carray(i,j));
                end
            end
            
            buff_Cdownm_Cter_r = obj.add_mismatch(buff_Cdownm_Cter_r);
            buff_Cdownm_Cter_l = obj.add_mismatch(buff_Cdownm_Cter_l);
            
            for i = 1:length(buff_bigdown_cap)
                buff_bigdown_cap(i) = obj.add_mismatch(buff_bigdown_cap(i));
            end
            
            
            
            %coarse array
            buff123 = fliplr(sum(buff_Cupm_Carray, 2)');
            obj.Cdownm.coarse = [buff123(2:end) buff_Cupm_Cter_l buff_Cupm_Cter_r];
            obj.Cupm.coarse = buff_bigup_cap;
            
            %fine array
            buff123 = [buff_bigup_cap(1:end-2) sum(buff_bigup_cap(end-1:end))];
            buff456 = buff_Cupm_Carray;
            buff456(end,:) = buff123;
            
            obj.Cupm.Carray = buff456;
            obj.Cupm.Cter_r = buff_Cupm_Cter_r;
            obj.Cupm.Cter_l = buff_Cupm_Cter_l;
            
            buff123 = [buff_bigdown_cap(1:end-2) sum(buff_bigdown_cap(end-1:end))];
            buff456 = buff_Cdownm_Carray;
            buff456(end,:) = buff123;
            
            obj.Cdownm.Carray = buff456;
            obj.Cdownm.Cter_r = buff_Cdownm_Cter_r;
            obj.Cdownm.Cter_l = buff_Cdownm_Cter_l;
%             
%             obj.Cdownm.Carray = buff(1:ceil((N-2)/2),1:ceil((N-2)/2));
%             obj.Cdownm.Cter_r = 1;
%             obj.Cdownm.Cter_l = 1;
            obj.Vouts = obj.get_Vouts();
            obj.DNL = get_DNL(obj);
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
    methods (Access = private)
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
            %get outputs at all codes
            N = obj.res;
            N_t = ceil(obj.res/2)*2;
            k = ceil(N/2); %coarse res
            Vout = zeros(1,2^N-1);
            for i = 1:2^(N/2)-1
                index = i*2^(N/2);
                [code_up, code_down] = obj.getCode(i);
%                 obj.Vref*(code_up*obj.Cupm.coarse' + code_down*obj.Cdownm.coarse')
                Vout(index) = obj.Vref*(code_up*obj.Cupm.coarse' + code_down*obj.Cdownm.coarse')/(sum(obj.Cupm.coarse+obj.Cdownm.coarse) + obj.load_cap);
            end

            
%             fine stage
            
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
            N = obj.res/2;
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
        function [y, z] = getCode(obj, u)
            %sets the cap arrangement for cap split
            N = obj.res/2;
            Vin = (u);
            %Vref = obj.Vref;
            Vref = 1;
            Vup = 2^(N);
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
        
        
    end
end