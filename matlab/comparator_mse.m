% mse = [];
power = [];
N = 10;
%k = 2;
Vref = 1;
lsb = Vref/2^N;
%Plsb = (23.2e-15)*(7.1e8)/lsb^2;
Plsb = 3e-14;
Pbudget = 175*Plsb;
tic
mse_budget = 0.18;
for k = 3:N-1
    
    
    
    x0 = [0,0];
%     x0(1) = Plsb;
%     x0(2) = sqrt(((Pbudget/(Plsb*lsb^2) - (N-k)/x0(1)^2)^-1)*k);
    x0(1) = 0.5;
    x0(2) = 0.5;
    [a, b]= power_constraint(x0, k, N);
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = [0 0];
    ub = [];
    a = Comparator_fns(N, k, Plsb, Pbudget, mse_budget);
%     options = optimoptions(@fmincon,'Algorithm','interior-point','OptimalityTolerance',1e-30, 'StepTolerance', 1e-30, 'ConstraintTolerance', 1e-30, 'MaxIterations', 10e3, 'MaxFunctionEvaluations', 1e5)
    options = optimoptions(@fmincon,'Algorithm','interior-point','OptimalityTolerance',1e-30, 'StepTolerance', 1e-30, 'ConstraintTolerance', 1e-3, 'MaxIterations', 10e3, 'MaxFunctionEvaluations', 1e5)
    
    %options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
    k
%     x = fmincon(@a.MSE_prox,x0,A,b,Aeq,beq,lb,ub,@a.power_constraint_prox, options)
    x = fmincon(@a.power_prox,x0,A,b,Aeq,beq,lb,ub,@a.mse_constraint_prox, options)
    
    norm = x*2^10
    %x = fmincon(@MSE,x0,A,b,Aeq,beq,lb,ub,@power_constraint)
    
%     mse = [mse a.MSE_prox(x)]
    power = [power a.power_prox(x)]
end

% best_k = find(mse == min(mse)) + 2
best_k = find(power == min(power)) + 2
toc
%Pbudget = 175
%k MSB
%k          1           2
%var1    0.80722    0.75753
%var2    2.26564    2.03751
%MSE     0.16173