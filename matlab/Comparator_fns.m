classdef Comparator_fns
    properties (Access = public)
        type
        Vref
        N
        k
        
    end

    methods
        function obj = Comparator_fns(name, k)
            obj.type = name;
            obj.N = 8;
            obj.k = k;
            obj.Vref = 1;
        end

        function [c,ceq] = power_constraint(x)
            %comparator power constraint
            Vref = 1;
            N = 8;
            k = 2;
            Plsb = 1e-6;
            Pbudget = 175*Plsb;
            lsb = Vref/2^N;

            c = [];
            ceq = ((N-k)/x(1)^2 + k/x(2)^2)*(lsb^2)*Plsb - Pbudget;
        end
        function y = MSE_prox(obj, u)
            %MSE formula from the paper
            y = MSE(u, obj.k, obj.N);
        end
        function [c,ceq] = power_constraint_prox(obj, x)
            [c,ceq] = power_constraint(x, obj.k, obj.N);
        end


        
    end
end