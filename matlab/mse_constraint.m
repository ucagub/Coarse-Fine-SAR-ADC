function [c,ceq] = mse_constraint(x, k, N)
    %comparator mse constraint
    Vref = 1;
    %N = 8;
    %k = 2;
    Plsb = 1e-6;
    CodeMSE = 0.18;
    lsb = Vref/2^N;
    
    c = [];
    ceq = MSE(x, k, N) - CodeMSE;
end