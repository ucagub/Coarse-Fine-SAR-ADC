function y = Con_DAC_mismatch(u)
    inCode = de2bi(u,8);
    Cap = 1e-15;
    Cu = 1*Cap;
    sigma_Cu = 0.05;
    LSB = 1/2^8;
    Cmm = zeros(1,8);

    Carray = Cu.*[2^0 2^1 2^2 2^3 2^4 2^5 2^6 2^7];
    
    for a = 1:8
        sigma = Carray(a)*sigma_Cu/sqrt(2^(a-1));
        Cmm(a) = normrnd(Carray(a),sigma);
    end
    Ctot = sum(Cmm) + normrnd(Cu,Cu*sigma_Cu);
    Cup_tot = inCode*Carray';
    y = Cup_tot/Ctot;
end


