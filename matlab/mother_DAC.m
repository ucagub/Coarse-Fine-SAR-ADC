classdef mother_DAC < handle
    properties
        type
        Vref
        mismatch
        res
        Cu
        load_cap
        droop
    end
    properties (Access = private)
        process_m = 0.008 %process_mismatch_constant
        area_prop %area_proportionality
    end
    methods 
        function obj = mother_DAC(N, Cu, dac_type, varargin)
            %(resolution, unit_cap, dac_type, load_cap, droop)
            obj.Vref = 1;
            obj.type = dac_type;
            obj.res = N;
            obj.droop = 0;
            obj.load_cap = 0;
            if strcmp(Cu, 'Default')
                obj.Cu = 1e-15;
            else
                obj.Cu = Cu;
            end
            switch nargin
                case 4
                    obj.load_cap = varargin{1};
                case 5
                    obj.load_cap = varargin{1};
                    obj.droop = varargin{2};
            end
            obj.area_prop = obj.Cu/1e-15;
            obj.mismatch = obj.process_m/sqrt(obj.area_prop); 
        end
    end
end