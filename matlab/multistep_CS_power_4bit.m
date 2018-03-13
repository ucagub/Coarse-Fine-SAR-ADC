
function y = multistep_CS_power_4bit(Vin)
    Vref = 1;


    SCA1_array = [1 1 1 1];
    SCA2_array = [1 1 1 1];

    SCA1_code = [1 1 0 0];
    SCA2_code = [1 1 0 0];

    D_out = [0 0 0 0];


    Etotal = 0;

    Vi1 = zeros(1,4);




    %coarse


    Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
    Vf1 = Vout - SCA1_code*Vref;
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)');
    Vi1 = Vf1;
    
    if Vin >= Vout
        SCA1_code(3) = 1;
        D_out(1) = 1;
    else
        SCA1_code(1) = 0;
    end



    Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
    Vf1 = Vout - SCA1_code*Vref;
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)');
    Etotal = Etotal*2;
    Vi1 = Vf1;
    Vi2 = Vf1;
    
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

    Vf1 = SCA1_bound - SCA1_code*Vref;
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)');
    Vi1 = Vf1;

    Vf2 = SCA2_bound - SCA2_code*Vref;
    Etotal = Etotal - Vref*(SCA2_array*((Vf2-Vi2).*SCA2_code)');
    Vi2 = Vf2;




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

    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)') - Vref*(SCA2_array*((Vf2-Vi2).*SCA2_code)');
    Vi1 = Vf1;
    Vi2 = Vf2;



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

    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)') - Vref*(SCA2_array*((Vf2-Vi2).*SCA2_code)');
    Vi1 = Vf1;
    Vi2 = Vf2;



    if Vin >= Vout
        D_out(4) = 1;
    end


    y = Etotal;
    
end