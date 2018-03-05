classdef multistep_CS_4bit < mother_DAC
    properties (Access = public)
        DNL
        SCA1_arraym
        SCA2_arraym
        skip_bits
        Vouts
    end

    methods
        function obj = multistep_CS_4bit(N, varargin)
            %(resolution, Cu, skip_bits )
            switch nargin
                case 1
                    skip_bits = [];
                    Cu = 'Default';
                case 2
                    skip_bits = [];
                    Cu = varargin{1};
                case 3
                    Cu = varargin{1};
                    skip_bits = varargin{2};
            end
            obj@mother_DAC(N, Cu, 'multistep_CS_4bit');
            obj.skip_bits = skip_bits;
            [obj.SCA1_arraym , obj.SCA2_arraym] = init_mismatch(obj);
            obj.Vouts = obj.get_Vouts();
        end
        function y = eval(obj, Vin)
            N = obj.res;
            if Vin == 0
                y = 0;
            elseif Vin == 2^N
                y = obj.Vref;
            else
                y = obj.Vouts(Vin);
            end
        end
        function Vouts = get_Vouts(obj)
            N = obj.res; 
            buff = zeros(1,2^N-1);
            for i = 1:2^N-1
                buff(i) = obj.evals(i);
            end
            
            Vouts = buff;
        end
        function y = evals(obj,Vin)
            Vin = Vin/(2^(obj.res));
            Vref = obj.Vref;


            SCA1_array = [1 1 1 1];
            SCA2_array = [1 1 1 1];

            SCA1_code = [1 1 0 0];
            SCA2_code = [1 1 0 0];

            D_out = [0 0 0 0];



            


            %coarse


            Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
            if Vout == Vin
                y = obj.SCA1_arraym*SCA1_code' / sum(obj.SCA1_arraym);
            end

            if Vin >= Vout
                SCA1_code(3) = 1;
                D_out(1) = 1;
            else
                SCA1_code(1) = 0;
            end


            
            Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
            if Vout == Vin
                y = obj.SCA1_arraym*SCA1_code' / sum(obj.SCA1_arraym);
            end

            SCA2_code = SCA1_code;
            if Vin >= Vout
                SCA2_code(4) = 1;
                D_out(2) = 1;
            else
                SCA2_code(2) = 0;
            end



            %fine

            SCA1_conn = [0 0 1 0];
            SCA2_conn = [0 0 1 0];
            SCA1_on = [0 0 1 0];
            SCA2_on = [0 0 1 0];
            SCA1_bound = SCA1_code*SCA1_array' / sum(SCA1_array);
            SCA2_bound = SCA2_code*SCA2_array' / sum(SCA2_array);






            if SCA1_bound > SCA2_bound
                up = 1;
            else
                up = 2;
            end
            % A = Cup1
            % B = Cup2
            % C = Cdown1
            % D = Cdown2

            A = SCA1_array.*SCA1_conn*SCA1_code' ;
            C = sum(SCA1_array.*SCA1_conn) - SCA1_array.*SCA1_conn*SCA1_code';
            B = SCA2_array.*SCA2_conn*SCA2_code' ;
            D = sum(SCA2_array.*SCA2_conn) - SCA2_array.*SCA2_conn*SCA2_code';
            X = SCA1_bound;
            Y = SCA2_bound;
            Vout = ( A*(X-Vref)+C*X+B*(Y-Vref)+D*Y+Vref*(A+B) ) / (A+B+C+D);
            if Vout == Vin
                A = obj.SCA1_arraym.*SCA1_conn*SCA1_code' ;
                C = sum(obj.SCA1_arraym.*SCA1_conn) - obj.SCA1_arraym.*SCA1_conn*SCA1_code';
                B = obj.SCA2_arraym.*SCA2_conn*SCA2_code' ;
                D = sum(obj.SCA2_arraym.*SCA2_conn) - obj.SCA2_arraym.*SCA2_conn*SCA2_code';
                X = SCA1_bound;
                Y = SCA2_bound;
                y = ( A*(X-Vref)+C*X+B*(Y-Vref)+D*Y+Vref*(A+B) ) / (A+B+C+D);
            end


            if (Vin >= Vout && up == 1) || (Vin < Vout && up == 2)
                SCA1_on(1) = 1;
                SCA1_on(2) = 1;
            else
                SCA2_on(1) = 1;
                SCA2_on(2) = 1;
            end
            if Vin >= Vout
                D_out(3) = 1;
            end
            SCA1_conn = SCA1_on.*[1 1 1 1];
            SCA2_conn = SCA2_on.*[1 1 1 1];

            A = SCA1_array.*SCA1_conn*SCA1_code' ;
            C = sum(SCA1_array.*SCA1_conn) - SCA1_array.*SCA1_conn*SCA1_code';
            B = SCA2_array.*SCA2_conn*SCA2_code' ;
            D = sum(SCA2_array.*SCA2_conn) - SCA2_array.*SCA2_conn*SCA2_code';
            X = SCA1_bound;
            Y = SCA2_bound;
            Vout = ( A*(X-Vref)+C*X+B*(Y-Vref)+D*Y+Vref*(A+B) ) / (A+B+C+D);
            if Vout == Vin
                A = obj.SCA1_arraym.*SCA1_conn*SCA1_code' ;
                C = sum(obj.SCA1_arraym.*SCA1_conn) - obj.SCA1_arraym.*SCA1_conn*SCA1_code';
                B = obj.SCA2_arraym.*SCA2_conn*SCA2_code' ;
                D = sum(obj.SCA2_arraym.*SCA2_conn) - obj.SCA2_arraym.*SCA2_conn*SCA2_code';
                X = SCA1_bound;
                Y = SCA2_bound;
                y = ( A*(X-Vref)+C*X+B*(Y-Vref)+D*Y+Vref*(A+B) ) / (A+B+C+D);
            end


            if Vin >= Vout
                D_out(4) = 1;
            end


            
        end
        function [y, z] = init_mismatch(obj)
            Cu = obj.mismatch;
            sigma_Cu = obj.mismatch;


            SCA1_array = [1 1 1 1];
            SCA2_array = [1 1 1 1];


            %initialize Cupm Cdownm
            SCA1_arraym = SCA1_array;
            SCA2_arraym = SCA2_array;

            for a = 1:4
                sigma = Cu*SCA1_array(a)*sigma_Cu/sqrt(SCA1_array(a));
                SCA1_arraym(a) = normrnd(Cu*SCA1_array(a),sigma);
            end
            for a = 1:4
                sigma = Cu*SCA2_array(a)*sigma_Cu/sqrt(SCA2_array(a));
                SCA2_arraym(a) = normrnd(Cu*SCA2_array(a),sigma);
            end

            y = SCA1_arraym;
            z = SCA2_arraym;
        end

    end
end

