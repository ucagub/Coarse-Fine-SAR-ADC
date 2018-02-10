classdef ADC
    properties (Access = public)
        Vref
        res
        k %MSBs
        fine_dac
        fine_dac_type
        fine_mismatch
        coarse_dac
        coarse_dac_type
        coarse_mismatch
        coarse_comp_noise
        fine_comp_noise
        Etotal_dac
        Emean
        ENOB
    end
    methods
        function obj = ADC(N, varargin)
            obj.Vref = 1;
            obj.res = N;
            obj.fine_comp_noise = 0;
            obj.coarse_comp_noise = 0; 
            
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
                    %(N = resolution, dac_type, mismatch)
                    obj.k = 8;
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
                    end
                case 6
                    %(N = resolution, k = coarse_res, coarse_dac_type, coarse_mismatch, fine_dac_type, fine_mismatch)
                    obj.k = varargin{1};
                    obj.coarse_dac_type = varargin{2};
                    obj.coarse_mismatch = varargin{3};
                    obj.fine_dac_type = varargin{4};
                    obj.fine_mismatch = varargin{5};
                    
                    if strcmp(obj.coarse_dac_type, 'CS_DAC')
                        obj.coarse_dac = DAC(obj.k, obj.coarse_mismatch);
                    elseif strcmp(obj.coarse_dac_type, 'JS_DAC')
                        obj.coarse_dac = JS_DAC(obj.k, obj.coarse_mismatch);
                    elseif strcmp(obj.coarse_dac_type, 'multistep_CS')
                        obj.coarse_dac = multistep_CS(obj.k,obj.coarse_mismatch);
                    elseif strcmp(obj.coarse_dac_type, 'TSJS_DAC')
                        obj.coarse_dac = TSJS_DAC(obj.k,obj.coarse_mismatch);
                    end
                    
                    if strcmp(obj.fine_dac_type, 'CS_DAC')
                        obj.fine_dac = DAC(N, obj.fine_mismatch, obj.k);
                    elseif strcmp(obj.fine_dac_type, 'JS_DAC')
                        obj.fine_dac = JS_DAC(N, obj.fine_mismatch, obj.k);
                    elseif strcmp(obj.fine_dac_type, 'multistep_CS')
                        obj.fine_dac = multistep_CS(N, obj.fine_mismatch, obj.k);
                    elseif strcmp(obj.fine_dac_type, 'TSJS_DAC')
                        obj.fine_dac = TSJS_DAC(N, obj.fine_mismatch, obj.k);
                    end
%                     obj.Etotal_dac = obj.fine_dac.Epercycle + Ecoarse_dac(obj.coarse_dac, obj.res);
%                     obj.Emean = mean(obj.Etotal_dac);
                case 8
                    %(N = resolution, k = coarse_res, coarse_dac_type, coarse_mismatch, fine_dac_type, fine_mismatch, coarse_comp_noise, fine_comp_noise)
                    obj.k = varargin{1};
                    obj.coarse_dac_type = varargin{2};
                    obj.coarse_mismatch = varargin{3};
                    obj.fine_dac_type = varargin{4};
                    obj.fine_mismatch = varargin{5};
                    obj.coarse_comp_noise = varargin{6}; 
                    obj.fine_comp_noise = varargin{7};
                    
                    if strcmp(obj.coarse_dac_type, 'CS_DAC')
                        obj.coarse_dac = DAC(obj.k, obj.coarse_mismatch);
                    elseif strcmp(obj.coarse_dac_type, 'JS_DAC')
                        obj.coarse_dac = JS_DAC(obj.k, obj.coarse_mismatch);
                    elseif strcmp(obj.coarse_dac_type, 'multistep_CS')
                        obj.coarse_dac = multistep_CS(obj.k,obj.coarse_mismatch);
                    elseif strcmp(obj.coarse_dac_type, 'TSJS_DAC')
                        obj.coarse_dac = TSJS_DAC(obj.k,obj.coarse_mismatch);
                    end
                    
                    if strcmp(obj.fine_dac_type, 'CS_DAC')
                        obj.fine_dac = DAC(N, obj.fine_mismatch, obj.k);
                    elseif strcmp(obj.fine_dac_type, 'JS_DAC')
                        obj.fine_dac = JS_DAC(N, obj.fine_mismatch, obj.k);
                    elseif strcmp(obj.fine_dac_type, 'multistep_CS')
                        obj.fine_dac = multistep_CS(N, obj.fine_mismatch, obj.k);
                    elseif strcmp(obj.coarse_dac_type, 'TSJS_DAC')
                        obj.coarse_dac = TSJS_DAC(N, obj.fine_mismatch, obj.k);
                    end
%                     obj.Etotal_dac = obj.fine_dac.Epercycle + Ecoarse_dac(obj.coarse_dac, obj.res);
%                     obj.Emean = mean(obj.Etotal_dac);
            
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
                    buff2 = ((Vup+Vdown)/2)/2^(N-obj.k);
                    %if Vin > obj.coarse_dac.eval(buff2)
                    if obj.coarse_comp(Vin, obj.coarse_dac.eval(buff2))
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
                    if obj.fine_comp(Vin, obj.fine_dac.eval((Vup+Vdown)/2))
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