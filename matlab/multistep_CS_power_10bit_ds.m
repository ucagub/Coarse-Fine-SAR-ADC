function y = multistep_CS_power_10bit_ds(Vin, k)
    Vref = 1;

    Vi1 = zeros(1,13);
    Etotal = 0;

    SCA1_array = [8 4 2 1 1 4 2 2 2 2 2 1 1];
    SCA2_array = [8 4 2 1 1 4 2 2 2 2 2 1 1];

    SCA1_code = [1 1 1 1 1 0 0 0 0 0 0 0 0];
    SCA2_code = [1 1 1 1 1 0 0 0 0 0 0 0 0];

    D_out = [0 0 0 0 0 0 0 0 0 0];


    % 8 4 2 1 1 - 4 2 2 - 2  2 - 2  - 1  1
    % 1 2 3 4 5 - 6 7 8 - 9 10 - 11 - 12 13

    
    coarse_bits = de2bi(Vin*1024,10,'left-msb');

    %coarse

    Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
    Vf1 = Vout - SCA1_code*Vref;
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)');
    Vi1 = Vf1;

    if Vin >= Vout
        SCA1_code(6) = 1;
        SCA1_code(7) = 1;
        SCA1_code(8) = 1;
        D_out(1) = 1;
    else
        SCA1_code(1) = 0;
    end

    if(k == 1)
        Etotal = 0;
        Vi1 = zeros(1,13);
        Vi2 = zeros(1,13);
        SCA1_code = [0 0 0 0 1 0 0 0 0 0 0 0 0];
        if(coarse_bits(1) == 1)
            SCA1_code = SCA1_code | [1 0 0 0 0 1 1 1 0 0 0 0 0];
        end
    end


    Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
    Vf1 = Vout - SCA1_code*Vref;
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)');
    Vi1 = Vf1;

    if Vin >= Vout
        SCA1_code(9) = 1;
        SCA1_code(10) = 1;
        D_out(2) = 1;
    else
        SCA1_code(2) = 0;
    end

    if(k == 2)
        Etotal = 0;
        Vi1 = zeros(1,13);
        Vi2 = zeros(1,13);
        SCA1_code = [0 0 0 0 1 0 0 0 0 0 0 0 0];
        if(coarse_bits(1) == 1)
            SCA1_code = SCA1_code | [1 0 0 0 0 1 1 1 0 0 0 0 0];
        end
        if(coarse_bits(2) == 1)
            SCA1_code = SCA1_code | [0 1 0 0 0 0 0 0 1 1 0 0 0];
        end
    end

    Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
    Vf1 = Vout - SCA1_code*Vref;
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)');
    Vi1 = Vf1;

    if Vin >= Vout
        SCA1_code(11) = 1;
        D_out(3) = 1;
    else
        SCA1_code(3) = 0;
    end

    if(k == 3)
        Etotal = 0;
        Vi1 = zeros(1,13);
        Vi2 = zeros(1,13);
        SCA1_code = [0 0 0 0 1 0 0 0 0 0 0 0 0];
        if(coarse_bits(1) == 1)
            SCA1_code = SCA1_code | [1 0 0 0 0 1 1 1 0 0 0 0 0];
        end
        if(coarse_bits(2) == 1)
            SCA1_code = SCA1_code | [0 1 0 0 0 0 0 0 1 1 0 0 0];
        end
        if(coarse_bits(3) == 1)
            SCA1_code = SCA1_code | [0 0 1 0 0 0 0 0 0 0 1 0 0];
        end
    end

    Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
    Vf1 = Vout - SCA1_code*Vref;
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)');
    Vi1 = Vf1;

    SCA2_code = SCA1_code;
    if Vin >= Vout
        SCA1_code(12) = 1;
        D_out(4) = 1;
    else
        SCA1_code(4) = 0;
    end

    if(k == 4)
        Etotal = 0;
        Vi1 = zeros(1,13);
        Vi2 = zeros(1,13);
        SCA1_code = [0 0 0 0 1 0 0 0 0 0 0 0 0];
        if(coarse_bits(1) == 1)
            SCA1_code = SCA1_code | [1 0 0 0 0 1 1 1 0 0 0 0 0];
        end
        if(coarse_bits(2) == 1)
            SCA1_code = SCA1_code | [0 1 0 0 0 0 0 0 1 1 0 0 0];
        end
        if(coarse_bits(3) == 1)
            SCA1_code = SCA1_code | [0 0 1 0 0 0 0 0 0 0 1 0 0];
        end
        if(coarse_bits(4) == 1)
            SCA1_code = SCA1_code | [0 0 0 1 0 0 0 0 0 0 0 1 0];
        end
    end


    Vout = SCA1_array*SCA1_code' / sum(SCA1_array);
    Vf1 = Vout - SCA1_code*Vref;
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)');
    Etotal = Etotal*2;
    Vi1 = Vf1;
    Vi2 = Vf1;

    SCA2_code = SCA1_code;
    if Vin >= Vout
        SCA2_code(13) = 1;
        D_out(5) = 1;
    else
        SCA2_code(5) = 0;
    end


    %fine

    if(k == 5)
        Etotal = 0;
        Vi1 = zeros(1,13);
        Vi2 = zeros(1,13);
        SCA1_code = [0 0 0 0 1 0 0 0 0 0 0 0 0];
        if(coarse_bits(1) == 1)
            SCA1_code = SCA1_code | [1 0 0 0 0 1 1 1 0 0 0 0 0];
        end
        if(coarse_bits(2) == 1)
            SCA1_code = SCA1_code | [0 1 0 0 0 0 0 0 1 1 0 0 0];
        end
        if(coarse_bits(3) == 1)
            SCA1_code = SCA1_code | [0 0 1 0 0 0 0 0 0 0 1 0 0];
        end
        if(coarse_bits(4) == 1)
            SCA1_code = SCA1_code | [0 0 0 1 0 0 0 0 0 0 0 1 0];
        end
        if(coarse_bits(5) == 1)
            SCA2_code = SCA1_code | [0 0 0 0 0 0 0 0 0 0 0 0 1];
        else
            SCA2_code = SCA1_code & [1 1 1 1 0 1 1 1 1 1 1 1 1];
        end
    end

    SCA1_conn = [0 0 0 0 0 0 0 0 0 0 0 1 0];
    SCA2_conn = [0 0 0 0 0 0 0 0 0 0 0 1 0];
    SCA1_on = [0 0 0 0 0 0 0 0 0 0 0 1 0];
    SCA2_on = [0 0 0 0 0 0 0 0 0 0 0 1 0];
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
    for i = 1:9
        if SCA1_conn(i) == 1
            Vf1(i) = Vout - SCA1_code(i)*Vref;
        end
        if SCA2_conn(i) == 1
            Vf2(i) = Vout - SCA2_code(i)*Vref;
        end
    end
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)') - Vref*(SCA2_array*((Vf2-Vi2).*SCA2_code)');
    Vi1 = Vf1;
    Vi2 = Vf2;

    if(k == 6)
    end

    if (Vin >= Vout && up == 1) || (Vin < Vout && up == 2)
        SCA1_on(11) = 1;
        SCA1_on(9) = 1;
        SCA1_on(6) = 1;
        SCA1_on(1) = 1;
    else
        SCA2_on(11) = 1;
        SCA2_on(9) = 1;
        SCA2_on(6) = 1;
        SCA2_on(1) = 1;
    end
    if Vin >= Vout
        D_out(6) = 1;
    end
    SCA1_conn = SCA1_on.*[0 0 0 0 0 0 0 0 0 0 1 1 1];
    SCA2_conn = SCA2_on.*[0 0 0 0 0 0 0 0 0 0 1 1 1];

    A = SCA1_array.*SCA1_conn*SCA1_code' ;
    C = sum(SCA1_array.*SCA1_conn) - SCA1_array.*SCA1_conn*SCA1_code';
    B = SCA2_array.*SCA2_conn*SCA2_code' ;
    D = sum(SCA2_array.*SCA2_conn) - SCA2_array.*SCA2_conn*SCA2_code';
    X = SCA1_bound;
    Y = SCA2_bound;
    Vout = ( A*(X-Vref)+C*X+B*(Y-Vref)+D*Y+Vref*(A+B) ) / (A+B+C+D);
    for i = 1:9
        if SCA1_conn(i) == 1
            Vf1(i) = Vout - SCA1_code(i)*Vref;
        end
        if SCA2_conn(i) == 1
            Vf2(i) = Vout - SCA2_code(i)*Vref;
        end
    end
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)') - Vref*(SCA2_array*((Vf2-Vi2).*SCA2_code)');
    Vi1 = Vf1;
    Vi2 = Vf2;

    if(k == 7)
    end

    if (Vin >= Vout && up == 1) || (Vin < Vout && up == 2)
        SCA1_on(10) = 1;
        SCA1_on(7) = 1;
        SCA1_on(2) = 1;
    else
        SCA2_on(10) = 1;
        SCA2_on(7) = 1;
        SCA2_on(2) = 1;
    end
    if Vin >= Vout
        D_out(7) = 1;
    end
    SCA1_conn = SCA1_on.*[0 0 0 0 0 0 0 0 1 1 1 1 1];
    SCA2_conn = SCA2_on.*[0 0 0 0 0 0 0 0 1 1 1 1 1];

    A = SCA1_array.*SCA1_conn*SCA1_code' ;
    C = sum(SCA1_array.*SCA1_conn) - SCA1_array.*SCA1_conn*SCA1_code';
    B = SCA2_array.*SCA2_conn*SCA2_code' ;
    D = sum(SCA2_array.*SCA2_conn) - SCA2_array.*SCA2_conn*SCA2_code';
    X = SCA1_bound;
    Y = SCA2_bound;
    Vout = ( A*(X-Vref)+C*X+B*(Y-Vref)+D*Y+Vref*(A+B) ) / (A+B+C+D);
    for i = 1:9
        if SCA1_conn(i) == 1
            Vf1(i) = Vout - SCA1_code(i)*Vref;
        end
        if SCA2_conn(i) == 1
            Vf2(i) = Vout - SCA2_code(i)*Vref;
        end
    end
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)') - Vref*(SCA2_array*((Vf2-Vi2).*SCA2_code)');
    Vi1 = Vf1;
    Vi2 = Vf2;

    if(k == 8)
    end

    if (Vin >= Vout && up == 1) || (Vin < Vout && up == 2)
        SCA1_on(8) = 1;
        SCA1_on(3) = 1;
    else
        SCA2_on(8) = 1;
        SCA2_on(3) = 1;
    end
    if Vin >= Vout
        D_out(8) = 1;
    end
    SCA1_conn = SCA1_on.*[0 0 0 0 0 1 1 1 1 1 1 1 1];
    SCA2_conn = SCA2_on.*[0 0 0 0 0 1 1 1 1 1 1 1 1];


    A = SCA1_array.*SCA1_conn*SCA1_code' ;
    C = sum(SCA1_array.*SCA1_conn) - SCA1_array.*SCA1_conn*SCA1_code';
    B = SCA2_array.*SCA2_conn*SCA2_code' ;
    D = sum(SCA2_array.*SCA2_conn) - SCA2_array.*SCA2_conn*SCA2_code';
    X = SCA1_bound;
    Y = SCA2_bound;
    Vout = ( A*(X-Vref)+C*X+B*(Y-Vref)+D*Y+Vref*(A+B) ) / (A+B+C+D);
    for i = 1:9
        if SCA1_conn(i) == 1
            Vf1(i) = Vout - SCA1_code(i)*Vref;
        end
        if SCA2_conn(i) == 1
            Vf2(i) = Vout - SCA2_code(i)*Vref;
        end
    end
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)') - Vref*(SCA2_array*((Vf2-Vi2).*SCA2_code)');
    Vi1 = Vf1;
    Vi2 = Vf2;

    if(k == 9)
    end

    if (Vin >= Vout && up == 1) || (Vin < Vout && up == 2)
        SCA1_on(4) = 1;
        SCA1_on(5) = 1;
    else
        SCA2_on(4) = 1;
        SCA2_on(5) = 1;
    end
    if Vin >= Vout
        D_out(9) = 1;
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
    for i = 1:9
        if SCA1_conn(i) == 1
            Vf1(i) = Vout - SCA1_code(i)*Vref;
        end
        if SCA2_conn(i) == 1
            Vf2(i) = Vout - SCA2_code(i)*Vref;
        end
    end
    Etotal = Etotal - Vref*(SCA1_array*((Vf1-Vi1).*SCA1_code)') - Vref*(SCA2_array*((Vf2-Vi2).*SCA2_code)');
    Vi1 = Vf1;
    Vi2 = Vf2;

    if Vin >= Vout
        D_out(10) = 1;
    end

    y = Etotal;
end