function [c,ceq] = mse_constraint(x, k, N)
    %comparator mse constraint
    Vref = 1;
    %N = 8;
    %k = 2;
    Plsb = 1e-6;
    CodeMSE = 0.18;
    lsb = Vref/2^N;
    %less than or equal to 0
    c(1) = -x(1) + 0.1031 ;
    c(2) = x(2) - 0.35;
    ceq = MSE(x, k, N) - CodeMSE;
end