function [c,ceq] = power_constraint(x)
    %comparator power constraint
    Vref = 1;
    N = 10;
    k = 7;
    Plsb = 1e-9;
    Pbudget = 175*Plsb;
    lsb = Vref/2^N;
    
    c = [];
    ceq = ((N-k)/x(1)^2 + k/x(2)^2)*(lsb^2)*Plsb - Pbudget;
end