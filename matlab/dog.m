classdef dog < handle
    properties
        bark
    end
    methods
        function obj = dog(bark)
            obj.bark = bark;
        end
        function tahol(obj)
            disp(obj.bark);
        end
    end
end