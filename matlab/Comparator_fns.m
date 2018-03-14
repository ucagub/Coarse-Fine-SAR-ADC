classdef Comparator_fns
    properties (Access = public)
        %type
        Vref
        N
        k
        Plsb
        Pbudget
        mse_budget
    end

    methods
        function obj = Comparator_fns(N, k, Plsb, Pbudget, mse_budget)
            %obj.type = name;
            obj.Pbudget = Pbudget;
            obj.Plsb = Plsb;
            obj.N = N;
            obj.k = k;
            obj.Vref = 1;
            obj.mse_budget = mse_budget;
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
            N = obj.N;
            k = obj.k;
            Vref = obj.Vref;
            Plsb = obj.Plsb;
            Pbudget = obj.Pbudget;
%             Plsb = 1e-6;
%             Pbudget = 175*Plsb;
            LSB  = Vref/2^N;
            
            c = [];
            ceq = ((N-k)/x(1)^2 + k/x(2)^2)*(LSB^2)*Plsb - Pbudget;
        end
        
        function [c, ceq] = mse_constraint_prox(obj,x)
     
%             c(1) = -x(1) + 0.1031 ;
%             c(2) = x(2) - 0.35;
            c = [];
            ceq = MSE(x, obj.k, obj.N) - obj.mse_budget;
            
        end
        
        function y = power_prox(obj, u)
            N = obj.N;
            k = obj.k;
            Vref = obj.Vref;;
            Plsb = obj.Plsb;
            LSB  = Vref/2^N;
%             y = ((N-k)/u(1)^2 + k/u(2)^2)*(LSB^2)*Plsb;

            a =   7.737e+04  (-5.522e+05, 7.069e+05);
            b =   -9.14e+14  (-1.498e+15, -3.296e+14);
            c =      0.2577  (-0.08901, 0.6044);
            d =  -4.572e+13  (-1.102e+14, 1.88e+13);
            buff = @(x) a*exp(b*x) + c*exp(d*x);
            y = (N-k)*buff(u(1)) + k*buff(u(2));
        end


        
    end
end