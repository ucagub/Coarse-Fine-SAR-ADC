classdef DAC_fns < handle
    properties (Access = public)
        k
        Ebudget
        ENOB_budget
        cs_coarse_energy
        cs_fine_energy
        cs_ENOB
        cs_SNDR
        fs
    end
    properties (Access = private)
        SNDR_mesh
    end

    methods
        function obj = DAC_fns(k, Ebudget, ENOB_budget)
            obj.Ebudget = Ebudget;
            obj.k = k;
            obj.ENOB_budget = ENOB_budget;
            obj.fs = 100e3;
            %cache cs energy factor
            load('cs_energy_k.mat', 'cs_coarse', 'cs_fine');
            obj.cs_coarse_energy = cs_fine{k};
            obj.cs_fine_energy = cs_coarse{k};
            load('cs_ENOB.mat', 'cs_ENOB');
            obj.cs_ENOB = cs_ENOB{k};
            load('cs-cs-3d-200ksps-loaded-with-noise-SNDR/katuparan_ng_pangarap.mat');
            obj.cs_SNDR = surfaces{k+1};
            [X, Y] = meshgrid(coarse_Cu,fine_Cu);
            buff = {};
            buff{1,1} = X;
            buff{1,2} = Y;
            obj.SNDR_mesh = buff; 
            
        end
        function set_Ebudget(obj, Ebudget)
            obj.Ebudget = Ebudget;
        end
        
        function y = FOM_prox(obj, u)
            %input: u = [coarse_Cu fine_Cu]
            %output schreier FOM
            y = obj.SNDR_prox(u) + log10(obj.fs/(2*obj.energy_prox(u)));
        end
        function y = SNDR_prox(obj, u)
            %SNDR interpolation fit from simulation
            %input: u = [coarse_Cu fine_Cu]
            
            y = interp2(obj.SNDR_mesh{1,1},obj.SNDR_mesh{1,2},obj.cs_SNDR,u(1),u(2));;
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
%             c(1) = 10e-15 - u(1);
%             c(2) = 10e-15 - u(2);
%             c(3) = u(1) - 70e-15;
%             c(4) = u(2) - 22e-15;
            c(1) = u(1) - 10e-15;
            c(2) = u(2)- 10e-15 ;
            c(3) = 70e-15 - u(1);
            c(4) = 22e-15 - u(2);

            c = [];
            buff = sum(obj.cs_coarse_energy*u(1) + obj.cs_fine_energy*u(2));
            ceq = buff - Ebudget;
        end
        function y = energy_prox(obj, u)
            %input: u = [coarse_Cu fine_Cu]
           
            y = sum(obj.cs_coarse_energy*u(1) + obj.cs_fine_energy*u(2));
        end
        function y = get_coarse_Cu(obj, energy, fine_Cu)
            %returns the needed coarse Cu to get energy given fine_Cu
            %inputs: energy and fine Cu
%             sum(obj.cs_coarse_energy)
%             sum(obj.cs_fine_energy)
            y = (energy - sum(obj.cs_fine_energy)*fine_Cu)/sum(obj.cs_coarse_energy);
        end
        function y = get_fine_Cu(obj, energy, coarse_Cu)
            %returns the needed fine Cu to get energy given coarse_Cu
            %inputs: energy and coarse Cu
            
            y = (energy - sum(obj.cs_coarse_energy)*coarse_Cu)/sum(obj.cs_fine_energy);
        end
        function y = get_endpoints(obj)
            buff_energy = obj.energy_prox([70e-15 10e-15]);
            if obj.Ebudget < buff_energy
                fine_Cu_left = 10e-15;
                coarse_Cu_left = obj.get_coarse_Cu(obj.Ebudget, 10e-15);
            else
                fine_Cu_left = obj.get_fine_Cu(obj.Ebudget, 70e-15); 
                coarse_Cu_left = 70e-15;
            end
            fine_Cu_right = obj.get_fine_Cu(obj.Ebudget, 10e-15);
%             buff_energy_right = obj.energy_prox([10e-15 22e-15]);
%             if obj.Ebudget > buff_energy_right
%                 fine_Cu_right = 
%             else
%                 fine_Cu_right = obj.get_fine_Cu(obj.Ebudget, 10e-15);
%             end
            
            y = [coarse_Cu_left fine_Cu_left; 10e-15 fine_Cu_right];
        end
    end
end