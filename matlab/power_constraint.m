function [c,ceq] = power_constraint(x, k, N)
    %comparator power constraint
    Vref = 1;
    %N = 8;
    %k = 2;
    Plsb = 1e-6;
    Pbudget = 175*Plsb;
    lsb = Vref/2^N;
    
    c = [];
    ceq = ((N-k)/x(1)^2 + k/x(2)^2)*(lsb^2)*Plsb - Pbudget;
end