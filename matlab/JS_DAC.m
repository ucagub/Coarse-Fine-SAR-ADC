function y = JS_DAC(u)

    Vref = 1;
    max_resolution = 8;
    expected_output = Vref*((u+1)/(2^max_resolution)); 
    inCode = de2bi(u,max_resolution);
    Cmin = 1e-15;
    %Ctotal = Cmin*2^resolution;
    %{
    Carray = [2];

    for i = 1:max_resolution-2
        Carray = [Carray 2^i];
    end
    Cbuff = Carray;

    for i = 1:max_resolution-1
        Cbuff = [Cbuff; Carray];
    end
    %Cbuff = Cbuff.*tril(ones(max_resolution-2,max_resolution-2));

    
    %}
    res = getRes(u, max_resolution);
    Cbuff = [2 0 0 0 0 0 0; 2 2 0 0 0 0 0; 2 2 4 0 0 0 0; 2 2 4 8 0 0 0; 2 2 4 8 16 0 0; 2 2 4 8 16 32 0; 2 2 4 8 16 32 64];
    %Cbuff(1:res-1,1:res-1)
    %inCode
    %(fliplr(inCode(max_resolution-res+2:max_resolution))')
    Cref = sum(Cbuff(1:res-1,1:res-1)*(fliplr(inCode(max_resolution-res+2:max_resolution))'));

    %y = (Cmin*(Sup*Cup' + Sdown*Cdown'))/Ctotal;
    y = getRes(u, max_resolution);
    %y = (Cref+1)/(2^res);
end
function y = getRes(u, max_res)
    i = 2^(max_res - 1);
    
    for res = 1:max_res
        if u > i
            i = i + 2^(max_res-1-res);
        elseif u < i 
            i = i - 2^(max_res-1-res);
        elseif u == i
            y = res;
            break
        end
    end
    y = res;
end