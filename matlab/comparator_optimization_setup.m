mse = [];
power = [];
N = 10;
%k = 2;
Vref = 1;
lsb = Vref/2^N;
Plsb = (14.5e-15)*(.32e-3)^2/lsb^2;
% Plsb = 30e-15;
% Plsb = 3e-14;
% Pbudget = 175*Plsb;
Pbudget = 300e-15;
tic
% mse_budget = .21264;
mse_budget = .145;
% mse_budget = .2;
enob = mse2enob(mse_budget)
norms = zeros(9,2);
for k = 1:N-1
    
    
    
    x0 = [0,0];
%     x0(1) = Plsb;
%     x0(2) = sqrt(((Pbudget/(Plsb*lsb^2) - (N-k)/x0(1)^2)^-1)*k);
    x0(1) = 0.01;
    x0(2) = 0.01;
%     [a, b]= power_constraint(x0, k, N);
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = [0 0];
    ub = [];
    a = Comparator_fns(N, k, Plsb, Pbudget, mse_budget);
%     options = optimoptions(@fmincon,'Algorithm','interior-point','OptimalityTolerance',1e-30, 'StepTolerance', 1e-30, 'ConstraintTolerance', 1e-30, 'MaxIterations', 10e3, 'MaxFunctionEvaluations', 1e5)
%     options = optimoptions(@fmincon,'Algorithm','interior-point','OptimalityTolerance',1e-21, 'StepTolerance', 1e-21, 'ConstraintTolerance', 1e-5, 'MaxIterations', 1e5, 'MaxFunctionEvaluations', 1e5)
    options = optimoptions(@fmincon,'Algorithm','sqp','OptimalityTolerance',1e-21, 'StepTolerance', 1e-21, 'ConstraintTolerance', 1e-5,'FunctionTolerance', 1e-30, 'MaxIterations', 1e5, 'MaxFunctionEvaluations', 1e5);
    
    %options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
    k
%     x = fmincon(@a.MSE_prox,x0,A,b,Aeq,beq,lb,ub,@a.power_constraint_prox, options)
    x = fmincon(@a.power_prox,x0,A,b,Aeq,beq,lb,ub,@a.mse_constraint_prox, options);
    
    norm = x*2^10;
    norms(k,:) = norm;
    %x = fmincon(@MSE,x0,A,b,Aeq,beq,lb,ub,@power_constraint)
    
    mse = [mse a.MSE_prox(x)];
    power = [power a.power_prox(x)];
end

% best_k = find(mse == min(mse)) + 2
best_k = find(power == min(power))
norms
toc
disp('finished')
%Pbudget = 175
%k MSB
%k          1           2
%var1    0.80722    0.75753
%var2    2.26564    2.03751
%MSE     0.16173