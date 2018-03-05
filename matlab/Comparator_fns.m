classdef Comparator_fns
    properties (Access = public)
        %type
        Vref
        N
        k
        Plsb
        Pbudget
    end

    methods
        function obj = Comparator_fns(N, k, Plsb, Pbudget)
            %obj.type = name;
            obj.Pbudget = Pbudget;
            obj.Plsb = Plsb;
            obj.N = N;
            obj.k = k;
            obj.Vref = 1;
        end

        function [c,ceq] = power_constraint(x)
            %comparator power constraint
            Vref = 1;
            N = obj.N;
            k = obj.k;
            Plsb = obj.Plsb;
            Pbudget = obj.Pbudget;
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