classdef ADC
    properties (Access = public)
        Vref
        res
        k %MSBs
        dac_k
        fine_dac
        fine_dac_type
        fine_Cu
        coarse_dac
        coarse_dac_type
        coarse_Cu
        coarse_comp_noise
        fine_comp_noise
        Etotal_dac
        Emean
        ENOB
        power
        load_cap
        droop
    end
    methods
        function obj = ADC(N, varargin)
            obj.Vref = 1;
            obj.res = N;
            obj.fine_comp_noise = 0;
            obj.coarse_comp_noise = 0; 
            obj.load_cap = 0;
            obj.droop = 0;
            switch nargin
                case 1
                case 2
                    %(N = resolution, dac_type)
                    obj.k = 8;
                    obj.fine_dac_type = varargin{1};
                    obj.coarse_dac_type = 'NONE';
                    if strcmp(obj.fine_dac_type, 'CS_DAC')
                        obj.fine_dac = DAC(N);
                    elseif strcmp(obj.fine_dac_type, 'JS_DAC')
                        obj.fine_dac = JS_DAC(N);
                    elseif strcmp(obj.fine_dac_type, 'multistep_CS')
                        obj.fine_dac = multistep_CS(N);
                    elseif strcmp(obj.fine_dac_type, 'TSJS_DAC')
                        obj.fine_dac = TSJS_DAC(N);
                    end
                case 3
                    %(N = resolution, dac_type, Cu)
                    obj.k = N;
                    obj.fine_dac_type = varargin{1};
                    obj.coarse_dac_type = 'NONE';
                    if strcmp(obj.fine_dac_type, 'CS_DAC')
                        obj.fine_dac = DAC(N, varargin{2});
                    elseif strcmp(obj.fine_dac_type, 'JS_DAC')
                        obj.fine_dac = JS_DAC(N, varargin{2});
                    elseif strcmp(obj.fine_dac_type, 'multistep_CS')
                        obj.fine_dac = multistep_CS(N,varargin{2});
                    elseif strcmp(obj.fine_dac_type, 'TSJS_DAC')
                        obj.fine_dac = TSJS_DAC(N,varargin{2});
                    elseif strcmp(obj.fine_dac_type, 'ideal_DAC')
                        obj.fine_dac = ideal_DAC(N,varargin{2});
                    elseif strcmp(obj.fine_dac_type, 'TSCS2_DAC')
                        obj.fine_dac = ideal_DAC(N,varargin{2});
                    end
                case 6
                    %(N = resolution, k = coarse_res, coarse_dac_type, coarse_mismatch, fine_dac_type, fine_mismatch)
                    obj.k = varargin{1};
                    obj.coarse_dac_type = varargin{2};
                    obj.coarse_Cu = varargin{3};
                    obj.fine_dac_type = varargin{4};
                    obj.fine_Cu = varargin{5};
                    
                    if strcmp(obj.coarse_dac_type, 'CS_DAC')
                        obj.coarse_dac = DAC(obj.k, obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'JS_DAC')
                        obj.coarse_dac = JS_DAC(obj.k, obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'multistep_CS')
                        obj.coarse_dac = multistep_CS(obj.k,obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'multistep_CS_6bit')
                        obj.coarse_dac = multistep_CS_4bit(obj.k,obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'multistep_CS_4bit')
                        obj.coarse_dac = multistep_CS_6bit(obj.k,obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'TSJS_DAC')
                        obj.coarse_dac = TSJS_DAC(obj.k,obj.coarse_Cu);
                    end
                    
                    if strcmp(obj.fine_dac_type, 'CS_DAC')
                        obj.fine_dac = DAC(N, obj.fine_Cu, obj.k);
                    elseif strcmp(obj.fine_dac_type, 'JS_DAC')
                        obj.fine_dac = JS_DAC(N, obj.fine_Cu, obj.k);
                    elseif strcmp(obj.fine_dac_type, 'multistep_CS')
                        obj.fine_dac = multistep_CS(N, obj.fine_Cu, obj.k);
                    elseif strcmp(obj.fine_dac_type, 'TSJS_DAC')
                        obj.fine_dac = TSJS_DAC(N, obj.fine_Cu, obj.k);
                    end
%                     obj.Etotal_dac = obj.fine_dac.Epercycle + Ecoarse_dac(obj.coarse_dac, obj.res);
%                     obj.Emean = mean(obj.Etotal_dac);
                case 9
                    %(N = resolution, k = coarse_res, dac_k, coarse_dac_type, coarse_Cu, fine_dac_type, fine_Cu, coarse_comp_noise, fine_comp_noise)
                    obj.k = varargin{1};
                    obj.dac_k = varargin{2};
                    obj.coarse_dac_type = varargin{3};
                    obj.coarse_Cu = varargin{4};
                    obj.fine_dac_type = varargin{5};
                    obj.fine_Cu = varargin{6};
                    obj.coarse_comp_noise = varargin{7}; 
                    obj.fine_comp_noise = varargin{8};
                    
                    if strcmp(obj.coarse_dac_type, 'CS_DAC')
                        obj.coarse_dac = DAC(obj.dac_k, obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'JS_DAC')
                        obj.coarse_dac = JS_DAC(obj.dac_k, obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'TSCS_DAC')
                        obj.coarse_dac = TSCS_DAC(obj.dac_k,obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'TSJS_DAC')
                        obj.coarse_dac = TSJS_DAC(obj.dac_k,obj.coarse_Cu);
                    end
                    
                    if strcmp(obj.fine_dac_type, 'CS_DAC')
                        obj.fine_dac = DAC(N, obj.fine_Cu, obj.dac_k);
                    elseif strcmp(obj.fine_dac_type, 'JS_DAC')
                        obj.fine_dac = JS_DAC(N, obj.fine_Cu, obj.dac_k);
                    elseif strcmp(obj.fine_dac_type, 'TSCS_DAC')
                        obj.fine_dac = TSCS_DAC(N, obj.fine_Cu, obj.dac_k);
                    elseif strcmp(obj.coarse_dac_type, 'TSJS_DAC')
                        obj.coarse_dac = TSJS_DAC(N, obj.fine_Cu, obj.dac_k);
                    end
%                     obj.Etotal_dac = obj.fine_dac.Epercycle + Ecoarse_dac(obj.coarse_dac, obj.res);
%                     obj.Emean = mean(obj.Etotal_dac);
%                     obj.power = obj.Emean*8/1e-3;
                case 10
                    %(N = resolution, k = coarse_res, dac_k, coarse_dac_type, coarse_Cu, fine_dac_type, fine_Cu, coarse_comp_noise, fine_comp_noise, load_cap)
                    obj.k = varargin{1};
                    obj.dac_k = varargin{2};
                    obj.coarse_dac_type = varargin{3};
                    obj.coarse_Cu = varargin{4};
                    obj.fine_dac_type = varargin{5};
                    obj.fine_Cu = varargin{6};
                    obj.coarse_comp_noise = varargin{7}; 
                    obj.fine_comp_noise = varargin{8};
                    obj.load_cap = varargin{9};
                    
                    if strcmp(obj.coarse_dac_type, 'CS_DAC')
                        obj.coarse_dac = DAC(obj.dac_k, obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'JS_DAC')
                        obj.coarse_dac = JS_DAC(obj.dac_k, obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'TSCS_DAC')
                        obj.coarse_dac = TSCS_DAC(obj.dac_k,obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'TSJS_DAC')
                        obj.coarse_dac = TSJS_DAC(obj.dac_k,obj.coarse_Cu);
                    end
                    
                    if strcmp(obj.fine_dac_type, 'CS_DAC')
                        obj.fine_dac = DAC(N, obj.fine_Cu, obj.dac_k);
                    elseif strcmp(obj.fine_dac_type, 'JS_DAC')
                        obj.fine_dac = JS_DAC(N, obj.fine_Cu, obj.dac_k);
                    elseif strcmp(obj.fine_dac_type, 'TSCS_DAC')
                        obj.fine_dac = TSCS_DAC(N, obj.fine_Cu, obj.dac_k);
                    elseif strcmp(obj.coarse_dac_type, 'TSJS_DAC')
                        obj.coarse_dac = TSJS_DAC(N, obj.fine_Cu, obj.dac_k);
                    end
                    obj.Etotal_dac = obj.fine_dac.Epercycle + Ecoarse_dac(obj.coarse_dac, obj.res);
                    obj.Emean = mean(obj.Etotal_dac);
%                     obj.power = obj.Emean*8/1e-3;
                case 11
                    %(N = resolution, k = coarse_res, dac_k, coarse_dac_type, coarse_Cu, fine_dac_type, fine_Cu, coarse_comp_noise, fine_comp_noise, load_cap, droop)
                    obj.k = varargin{1};
                    obj.dac_k = varargin{2};
                    obj.coarse_dac_type = varargin{3};
                    obj.coarse_Cu = varargin{4};
                    obj.fine_dac_type = varargin{5};
                    obj.fine_Cu = varargin{6};
                    obj.coarse_comp_noise = varargin{7}; 
                    obj.fine_comp_noise = varargin{8};
                    obj.load_cap = varargin{9};
                    obj.droop = varargin{10};
                    
                    if strcmp(obj.coarse_dac_type, 'CS_DAC')
                        obj.coarse_dac = DAC(obj.dac_k, obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'JS_DAC')
                        obj.coarse_dac = JS_DAC(obj.dac_k, obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'TSCS_DAC')
                        obj.coarse_dac = TSCS_DAC(obj.dac_k,obj.coarse_Cu);
                    elseif strcmp(obj.coarse_dac_type, 'TSJS_DAC')
                        obj.coarse_dac = TSJS_DAC(obj.dac_k,obj.coarse_Cu);
                    end
                    
                    if strcmp(obj.fine_dac_type, 'CS_DAC')
                        obj.fine_dac = DAC(N, obj.fine_Cu, obj.dac_k);
                    elseif strcmp(obj.fine_dac_type, 'JS_DAC')
                        obj.fine_dac = JS_DAC(N, obj.fine_Cu, obj.dac_k);
                    elseif strcmp(obj.fine_dac_type, 'TSCS_DAC')
                        obj.fine_dac = TSCS_DAC(N, obj.fine_Cu, obj.dac_k);
                    elseif strcmp(obj.coarse_dac_type, 'TSJS_DAC')
                        obj.coarse_dac = TSJS_DAC(N, obj.fine_Cu, obj.dac_k);
                    end
%                     obj.Etotal_dac = obj.fine_dac.Epercycle + Ecoarse_dac(obj.coarse_dac, obj.res);
%                     obj.Emean = mean(obj.Etotal_dac);
%                     obj.power = obj.Emean*8/1e-3;
            
            end
            obj.ENOB = obj.get_ENOB();
        end
        function y = quantizer(obj, Vin)
            %input : Vin ranging from 0 to Vref
            %output: quantized version of Vin
            
            buff = obj.digitize(Vin);
            y = obj.Vref*buff/(2^obj.res);
            
        end
        function y = digitize(obj, Vin)
            %input : Vin ranges form 0 to Vref
            %output: digital conversion in decimal format
            N = obj.res;
            Vref = obj.Vref;
            Vup = 2^N;
            Vdown = 0;
            buff_out = zeros(1,N);
            %if coarse_fine
            if obj.k < N
            	%coarse quantization
                for i = 1:obj.k
                    buff2 = (Vup+Vdown)/2;
                    %if Vin > obj.coarse_dac.eval(buff2)
                    if obj.coarse_comp(Vin, obj.DAC_eval(buff2, i))
                        Vdown = (Vup+Vdown)/2;
                        buff_out(i) = 1;
                    else
                        Vup = (Vup+Vdown)/2;
                        buff_out(i) = 0;
                    end 
                end
                %fine quantization
            
                for j = obj.k+1:N
                    %if Vin > obj.fine_dac.eval((Vup+Vdown)/2)
                    %j
                    if obj.fine_comp(Vin, obj.DAC_eval((Vup+Vdown)/2, j))
                        Vdown = (Vup+Vdown)/2;
                        buff_out(j) = 1;
                    else
                        Vup = (Vup+Vdown)/2;
                        buff_out(j) = 0;
                    end 
                end
           
            else
                %if fine only
                for i = 1:N
                    
                    if Vin > obj.fine_dac.eval((Vup+Vdown)/2)
                        Vdown = (Vup+Vdown)/2;
                        buff_out(i) = 1;
                    else
                        Vup = (Vup+Vdown)/2;
                        buff_out(i) = 0;
                    end 
                end
            end
            
            y = bi2de(buff_out, 'left-msb');
        end
                
        function plot_tf(obj, Vin)
            %plots the ADC transfer function
            tic
            in = [0:1e-6:1];
            out = zeros(1,length(in));
            parfor i = 1:length(in)
                out(i) = obj.digitize(in(i));
            end
            figure('Name', 'ADC transfer function');
            plot(in, out);
            xlabel('Vin');
            ylabel('Dout');
            toc
        end

    end
    methods (Access = private)
        function y = fine_comp(obj, Vin, ref)
            %returns logical 1 if Vin > ref + noise
            y = Vin > ref + normrnd(0, sqrt(obj.fine_comp_noise));
        end
        function y = coarse_comp(obj, Vin, ref)
            %returns logical 1 if Vin > ref + noise
            y = Vin > ref + normrnd(0, sqrt(obj.coarse_comp_noise));
        end
        function y = DAC_eval(obj, Vin, i)
            if i <= obj.dac_k
                y = obj.coarse_dac.eval(Vin/2^(obj.res-obj.dac_k)) - obj.droop;
            else
                y = obj.fine_dac.eval(Vin) - obj.droop;
            end
            return
        end
        function ENOB = get_ENOB(obj);
            fs = 3.17e4;
            f0 = 5e2;
            N = 1024*2;
            t = (0:N-1)/fs;

            y = 0.5*sin(2*pi*f0*t) + 0.5;
            z = zeros(1, length(y));
            for i = 1:length(y)
                z(i) = obj.quantizer(y(i));
            end
            b = sinad(z,fs);
            ENOB = (b-1.76)/6.02; 
        end
    end
end 

function y = Ecoarse_dac(coarse_dac, N)
    %inputs : coarse_dac object
    %       : k skip_bits
    %       : N resolution
    %returns: coarse_dac Epercycle
    bit_remain = N-coarse_dac.res;
    buff = zeros(1, 2^N);
    if strcmp(coarse_dac.type, 'CS_DAC')
        for i = 0:2^N-1
            %i
            buff(i+1) = coarse_dac.Epercycle(floor(i/(2^bit_remain)) +1);
        end
    elseif strcmp(coarse_dac.type, 'CS_DAC')
        for i = 0:2^N-2
            %i
            buff(i+1) = coarse_dac.Epercycle(floor(i/(2^bit_remain)) +1);
        end
        buff(2^N) = buff(1);
    end
    
    y = buff;
end