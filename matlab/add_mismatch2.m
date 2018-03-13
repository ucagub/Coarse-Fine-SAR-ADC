function y = add_mismatch2(Cap, sigma_Cu, u)
    %add mismatch to cap u
    %sigma_Cu = 0.05;
    buff = u;
    %Cap = 1e-15;
    Cu = 1*Cap;
    
    for j = 1:length(buff)
%         buff(j);
        sigma = Cu*buff(j)*sigma_Cu/sqrt(buff(j));
        buff(j) = normrnd(Cu*buff(j),sigma);
    end
    y = buff;
end