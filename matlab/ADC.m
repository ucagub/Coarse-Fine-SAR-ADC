classdef ADC
    properties (Access = public)
        Vref
        res
        dac
        comp
    end
    methods
        function obj = ADC(N, varargin)
            switch nargin
                case 1
                case 2
                    obj.Vref = 1;
                    obj.res = N;
                    if varargin{1} == 'CS_DAC'
                        obj.dac = DAC(N);
                    elseif varargin{1} == 'JS_DAC'
                        obj.dac = JS_DAC(N);
                    end
                case 3
                    obj.Vref = 1;
                    obj.res = N;
                    if varargin{1} == 'CS_DAC'
                        obj.dac = DAC(N, varargin{2});
                    elseif varargin{1} == 'JS_DAC'
                        obj.dac = JS_DAC(N, varargin{2});
                    end
            end
        end
        function y = quantizer(obj, Vin)
            %input : Vin ranging from 0 to Vref
            %output: quantized version of Vin
            
            N = obj.res;
            Vref = obj.Vref;
            Vup = 2^N;
            Vdown = 0;
            buff_out = zeros(1,N);
            for i = 1:N
                if Vin > obj.dac.eval((Vup+Vdown)/2)
                    Vdown = (Vup+Vdown)/2;
                    buff_out(i) = 1;
                else
                    Vup = (Vup+Vdown)/2;
                    buff_out(i) = 0;
                end 
            end
            y = Vref*bi2de(buff_out, 'left-msb')/(2^N);
            
        end
    end
end 