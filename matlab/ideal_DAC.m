classdef ideal_DAC < mother_DAC
    properties (Access = public)
        Vouts
    end
    methods
        function obj = ideal_DAC(N, Cu)
            %(resolution, Cu, skip_bits )
            obj@mother_DAC(N, Cu, 'ideal_DAC');
            obj.gen_Vouts()
            obj.init_mismatch()
        end
        
        function y = eval(obj, Vin)
            if Vin == 0
                Vout = 0;
            elseif Vin == 2^obj.res
                Vout = obj.Vref;
            else
                Vout = obj.Vouts(Vin);
            end
            y = Vout;
        end
    end
    methods (Access = private)
        function init_mismatch(obj)
            bit_cycle = 10;
            LSB = obj.Vref/2^(obj.res);
            %obj.Vouts(2^(obj.res-1)) = obj.Vouts(2^(obj.res-1)) + LSB;
            for i = 1:2:2^bit_cycle
                index = 2^obj.res*i/2^bit_cycle;
                obj.Vouts(index) = obj.Vouts(index) - 20*LSB;
            end
        end
        function gen_Vouts(obj)
            LSB = obj.Vref/2^(obj.res);
            buff = [1:((2^obj.res)-1)];
            obj.Vouts = buff*LSB;
        end
    end
end