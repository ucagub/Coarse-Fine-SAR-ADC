classdef mother_DAC < handle
    properties
        type
        Vref
        mismatch
        res
        Cu
        
    end
    properties (Access = private)
        process_m = 0.05 %process_mismatch_constant
        area_prop %area_proportionality
    end
    methods 
        function obj = mother_DAC(N, Cu, dac_type)
            obj.Vref = 1;
            obj.type = dac_type;
            obj.res = N;
            
            if strcmp(Cu, 'Default')
                obj.Cu = 1e-15;
            else
                obj.Cu = Cu;
            end
            obj.area_prop = obj.Cu/1e-15;
            obj.mismatch = obj.process_m/sqrt(obj.area_prop); 
        end
    end
end