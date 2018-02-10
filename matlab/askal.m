classdef askal < dog
    properties
        name
    end
    methods
        function obj = askal(name)
            obj@dog('woof');
            obj.name = name;
        end
    end
end