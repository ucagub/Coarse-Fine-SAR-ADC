classdef TSJS_DAC < handle
    properties (Access = public)
        type
        Vref
        %DNL
        %INL
        %Epercycle
        res
        Cupm
        Cdownm
        mismatch
        %skip_bits
        Vouts
    end
    methods
        function obj = TSJS_DAC(N, varargin)
            obj.type = 'TSJS_DAC';
            obj.Vref = 1;
            switch nargin
                case 1
                    obj.res = N;
                    obj.mismatch = 0;
                case 2
                    obj.res = N;
                    obj.mismatch = varargin{1};
                case 3
                    obj.res = N;
                    obj.mismatch = varargin{1};
                    obj.skip_bits = varargin{2};
                    
            end
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
%             obj.Cupm.Carray = arrayfun(@obj.add_mismatch, obj.Cupm.Carray);
%             obj.Cupm.Cter_r = obj.add_mismatch(obj.Cupm.Cter_r);
%             obj.Cupm.Cter_l = obj.add_mismatch(obj.Cupm.Cter_l);
%             
%             obj.Cdownm.Carray = arrayfun(@obj.add_mismatch, obj.Cdownm.Carray);
%             obj.Cdownm.Cter_r = obj.add_mismatch(obj.Cdownm.Cter_r);
%             obj.Cdownm.Cter_l = obj.add_mismatch(obj.Cdownm.Cter_l);
%             
            obj.init_mismatch();
            
            obj.Vouts = obj.get_Vouts();
            
        end
    end
    methods (Access = private)
        function y = add_mismatch(obj, u)
            %adds mismatch to each cap
            buff = u;
            Cap = 1e-15;
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
            N = obj.res;
            %buff = zeros(N,N);
            Vout = zeros(1,2^N-1);
            Vout(2^N/2) = obj.Cupm.Cter_r/(obj.Cupm.Cter_l + obj.Cupm.Cter_r);
            
            
            for i = 2:N/2
                for j = 1:2^(i-1)
                    %coarse stage
                    code = de2bi(j-1,i-1,'left-msb');
                    Cup = sum(obj.Cupm.Carray(1:i-1,1:i-1)*code') + obj.Cupm.Cter_l;
                    Ctot = sum(sum(obj.Cupm.Carray(1:i-1,1:i-1))) + (obj.Cupm.Cter_l + obj.Cupm.Cter_r);
                    %index = (2^N)*(j*2-1)/2^i;
                    Vout((2^N)*(j*2-1)/2^i) = obj.Vref*Cup/Ctot;
                end
            end
            %fine stage
%             k = ceil(N/2); %coarse res
%             for w = 1:2^(k-1)
%                 for stage = 1:k
%                     for p = 0:1
%                         index = (2^N)*(((p+1)*2-1 + (w-1)*4)/2^(k+1));
%                         if p == 0
%                             %termination cap bot plate connection 1 vref 0 gnd
%                             %[up down]
%                             config_ter_r = [0 0];
%                             Vup_bound = obj.get_Vup_bound(code);
%                             Vlow_bound = Vout((2^N)*(j*2-1)/2^i);
%                             Vout(index) = (obj.Cupm.Cter_r*Vup_bound + obj.Cdownm.Cter_r*Vlow_bound)/(obj.Cupm.Cter_r + obj.Cdownm.Cter_r);
%                         elseif p == 1
%                             %termination cap bot plate connection 1 vref 0 gnd
%                             %[up down]
%                             config_ter_r = [1 0];
%                             Vup_bound = Vout((2^N)*(j*2-1)/2^i);
%                             Vlow_bound = obj.get_Vlow_bound(code);
%                             Vout(index) = (obj.Cupm.Cter_r*(Vup_bound-obj.Vref) + obj.Cdownm.Cter_r*Vlow_bound + obj.Cupm.Cter_r*obj.Vref)/(obj.Cupm.Cter_r + obj.Cdownm.Cter_r);
%                         end
%                         for n = 2:N/2
%                             for m = 1:2^(n-1)
%                                 code = de2bi(m-1,n-1,'left-msb');
%                                 index = (2^N)*(m*2-1 + (w-1)*2^(n+1))/2^(k+n);
%                                 %Ccurr = Vup_bound*
%                                 %disp('sdf')
%                                 Vup_init = get_Varray(obj, code, Vup_bound);
%                                 Vdown_init = get_Varray(obj, code, Vlow_bound);
%                             end
%                         end
%                     end
%                 end
%             end
            
            
            

            
            y = Vout;
        end
        function Vup_bound = get_Vup_bound(obj, code)
            %set Cupm as the upper bound array
            N = obj.res;
            i = N/2;
            Cup = sum(obj.Cupm.Carray(1:i-1,1:i-1)*code') + (obj.Cupm.Cter_l + obj.Cupm.Cter_r);
            Ctot = sum(sum(obj.Cupm.Carray(1:i-1,1:i-1))) + (obj.Cupm.Cter_l + obj.Cupm.Cter_r);
            Vup_bound = obj.Vref*Cup/Ctot;
        end
        function Vlow_bound = get_Vlow_bound(obj, code)
            %set Cdownm as the lower bound array
            N = obj.res;
            i = N/2;
            Cup = sum(obj.Cdownm.Carray(1:i-1,1:i-1)*code');
            Ctot = sum(sum(obj.Cdownm.Carray(1:i-1,1:i-1))) + (obj.Cdownm.Cter_l + obj.Cdownm.Cter_r);
            Vlow_bound = obj.Vref*Cup/Ctot;
        end
        
        function Varray_final = get_Varray(obj, code, Vx)
            %returns the voltage for each cap at the given output code
            N = obj.res;
            Vref = obj.Vref;
            Varray_buff = zeros(ceil((N-2)/2),ceil((N-2)/2));
            %config = de2bi(code,N,'left-msb');
            %config
            %Vx = obj.eval(code);

            V1d = (Vx - Vref*code);
            for i = 1:ceil((N-2)/2)
                Varray_buff(:,i) = V1d(i);
            end
            Varray_final = Varray_buff.*tril(ones(3,3));
            %Varray_final = padarray(Varray_buff, [N-stage_num, N-stage_num], 'post');
            
        end
        function init_mismatch(obj)
            obj.Cupm.Carray = arrayfun(@obj.add_mismatch, obj.Cupm.Carray);
            obj.Cupm.Cter_r = obj.add_mismatch(obj.Cupm.Cter_r);
            obj.Cupm.Cter_l = obj.add_mismatch(obj.Cupm.Cter_l);
            
            obj.Cdownm.Carray = arrayfun(@obj.add_mismatch, obj.Cdownm.Carray);
            obj.Cdownm.Cter_r = obj.add_mismatch(obj.Cdownm.Cter_r);
            obj.Cdownm.Cter_l = obj.add_mismatch(obj.Cdownm.Cter_l);
        end
    end
end