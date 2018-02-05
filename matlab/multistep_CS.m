classdef multistep_CS
    properties (Access = public)
        type
        Vref
        DNL
        SCA1_arraym
        SCA2_arraym
        res
        mismatch
    end

    methods
        function obj = multistep_CS(N, varargin)
            %obj.type = name;
            obj.Vref = 1;
            switch nargin
                case 1
                    obj.res = N;
                    obj.mismatch = 0;
                case 2
                    obj.res = N;
                    obj.mismatch = varargin{1};
            end
            [obj.SCA1_arraym , obj.SCA2_arraym] = init_mismatch(obj.mismatch);
            obj.DNL = get_DNL(obj);

        end
        function y = eval(obj,Vin)
            Vin = Vin/256;
            Vref = 1;


            SCA1_array = [4 2 1 1 2 2 2 1 1];
            SCA2_array = [4 2 1 1 2 2 2 1 1];

            SCA1_code = [1 1 1 1 0 0 0 0 0];
            SCA2_code = [1 1 1 1 0 0 0 0 0];

            D_out = [0 0 0 0 0 0 0 0];



            


            %coarse


            Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
            if Vout == Vin
                y = obj.SCA1_arraym*SCA1_code' / sum(obj.SCA1_arraym);
            end

            if Vin >= Vout
                SCA1_code(5) = 1;
                SCA1_code(6) = 1;
                D_out(1) = 1;
            else
                SCA1_code(1) = 0;
            end


            Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
            if Vout == Vin
                y = obj.SCA1_arraym*SCA1_code' / sum(obj.SCA1_arraym);
            end

            if Vin >= Vout
                SCA1_code(7) = 1;
                D_out(2) = 1;
            else
                SCA1_code(2) = 0;
            end



            Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
            if Vout == Vin
                y = obj.SCA1_arraym*SCA1_code' / sum(obj.SCA1_arraym);
            end

            if Vin >= Vout
                SCA1_code(8) = 1;
                D_out(3) = 1;
            else
                SCA1_code(3) = 0;
            end



            Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
            if Vout == Vin
                y = obj.SCA1_arraym*SCA1_code' / sum(obj.SCA1_arraym);
            end

            SCA2_code = SCA1_code;
            if Vin >= Vout
                SCA2_code(9) = 1;
                D_out(4) = 1;
            else
                SCA2_code(4) = 0;
            end



            %fine

            SCA1_conn = [0 0 0 0 0 0 0 1 0];
            SCA2_conn = [0 0 0 0 0 0 0 1 0];
            SCA1_on = [0 0 0 0 0 0 0 1 0];
            SCA2_on = [0 0 0 0 0 0 0 1 0];
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
                SCA1_on(7) = 1;
                SCA1_on(6) = 1;
                SCA1_on(1) = 1;
            else
                SCA2_on(7) = 1;
                SCA2_on(6) = 1;
                SCA2_on(1) = 1;
            end
            if Vin >= Vout
                D_out(5) = 1;
            end
            SCA1_conn = SCA1_on.*[0 0 0 0 0 0 1 1 1];
            SCA2_conn = SCA2_on.*[0 0 0 0 0 0 1 1 1];

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
                SCA1_on(5) = 1;
                SCA1_on(2) = 1;
            else
                SCA2_on(5) = 1;
                SCA2_on(2) = 1;
            end
            if Vin >= Vout
                D_out(6) = 1;
            end
            SCA1_conn = SCA1_on.*[0 0 0 0 1 1 1 1 1];
            SCA2_conn = SCA2_on.*[0 0 0 0 1 1 1 1 1];


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
                SCA1_on(4) = 1;
                SCA1_on(3) = 1;
            else
                SCA2_on(4) = 1;
                SCA2_on(3) = 1;
            end
            if Vin >= Vout
                D_out(7) = 1;
            end
            SCA1_conn = SCA1_on;
            SCA2_conn = SCA2_on;

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
                D_out(8) = 1;
            end

            
        end

    end
end

function [y, z] = init_mismatch(sigma_Cu)
    Cu = 1e-15;


    SCA1_array = [4 2 1 1 2 2 2 1 1];
    SCA2_array = [4 2 1 1 2 2 2 1 1];
    
    %initialize Cupm Cdownm
    SCA1_arraym = SCA1_array;
    SCA2_arraym = SCA2_array;

    for a = 1:9
        sigma = Cu*SCA1_array(a)*sigma_Cu/sqrt(SCA1_array(a));
        SCA1_arraym(a) = normrnd(Cu*SCA1_array(a),sigma);
    end
    for a = 1:9
        sigma = Cu*SCA2_array(a)*sigma_Cu/sqrt(SCA2_array(a));
        SCA2_arraym(a) = normrnd(Cu*SCA2_array(a),sigma);
    end
    
    y = SCA1_arraym;
    z = SCA2_arraym;
end