classdef DAC_fns
    properties (Access = public)
        k
        Ebudget
        ENOB_budget
        cs_coarse_energy
        cs_fine_energy
        cs_ENOB
    end

    methods
        function obj = DAC_fns(k, Ebudget, ENOB_budget)
            obj.Ebudget = Ebudget;
            obj.k = k;
            obj.ENOB_budget = ENOB_budget;
            
            %cache cs energy factor
            load('cs_energy_k.mat', 'cs_coarse', 'cs_fine');
            obj.cs_coarse_energy = cs_coarse{k};
            obj.cs_fine_energy = cs_fine{k};
            load('cs_ENOB.mat', 'cs_ENOB');
            obj.cs_ENOB = cs_ENOB{k};
        end


        function y = ENOB_prox(obj, u)
            %ENOB fit from simulation
            %input: u = [coarse_Cu fine_Cu]
            
            y = obj.cs_ENOB(0.008/sqrt(u(1)/1e-15),0.008/sqrt(u(2)/1e-15));
        end

        
        function [c, ceq] = ENOB_constraint(obj,u)
            %input: u = [coarse_Cu fine_Cu]
     
%             c(1) = 5e-15 - u(1);
%             c(2) = 5e-15 - u(2);
            c = [];
            ceq = obj.cs_ENOB(0.008/sqrt(u(1)/1e-15),0.008/sqrt(u(2)/1e-15)) - obj.ENOB_budget;
            
        end
        function [c,ceq] = energy_constraint(obj, u)
            %DAC energy constraint
            %input: u = [coarse_Cu fine_Cu]
            Ebudget = obj.Ebudget;
%             c(1) = 5e-15 - u(1);
%             c(2) = 5e-15 - u(2);
            c = [];
            buff = sum(obj.cs_coarse_energy*u(1) + obj.cs_fine_energy*u(2));
            ceq = buff - Ebudget;
        end
        function y = energy_prox(obj, u)
            %input: u = [coarse_Cu fine_Cu]
           
            y = sum(obj.cs_coarse_energy*u(1) + obj.cs_fine_energy*u(2));
        end
    end
end