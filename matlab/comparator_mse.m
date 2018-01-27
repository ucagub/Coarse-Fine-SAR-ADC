mse = []
for k = 1:7
    
    Vref = 1;
    N = 8;
    %k = 2;
    Plsb = 1;
    Pbudget = 175*Plsb;
    lsb = Vref/2^N;
    x0 = [0,0];
    x0(1) = Plsb;
    x0(2) = sqrt(((Pbudget/(Plsb*lsb^2) - (N-k)/x0(1)^2)^-1)*k);
    [a, b]= power_constraint(x0, k, N);
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = [0 0];
    ub = [];
    a = Comparator_fns('sdf', k);
    options = optimoptions(@fmincon,'Algorithm','interior-point','OptimalityTolerance',1e-12, 'StepTolerance', 1e-12, 'ConstraintTolerance', 1e-12, 'MaxIterations', 5e3)
    %options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

    x = fmincon(@a.MSE_prox,x0,A,b,Aeq,beq,lb,ub,@a.power_constraint_prox, options);
    k
    norm = x*2^10
    %x = fmincon(@MSE,x0,A,b,Aeq,beq,lb,ub,@power_constraint)
    
    mse = [mse a.MSE_prox(x)];
end

best_k = find(mse == min(mse))
%Pbudget = 175
%k MSB
%k          1           2
%var1    0.80722    0.75753
%var2    2.26564    2.03751
%MSE     0.16173