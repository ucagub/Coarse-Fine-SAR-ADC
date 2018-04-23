ENOB = [];
energy = [];
Ebudget = 1e-12;
ENOB_budget = 9.8;
tic
% mse_budget = .21264;
% mse_budget = .145;


norms = zeros(9,2);
N=10;
for k = 1:N-1
    
    
    abc = DAC_fns(k, Ebudget, ENOB_budget);
    
    x0 = [0,0];
%     x0(1) = Plsb;
%     x0(2) = sqrt(((Pbudget/(Plsb*lsb^2) - (N-k)/x0(1)^2)^-1)*k);
    x0(1) = 30e-14;
    x0(2) = 12e-14;
%     [a, b]= abc.ENOB_constraint(x0);
%     [a, b]= abc.energy_constraint(x0);
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    lb = [];
    ub = [];
    abc.set_Ebudget(abc.energy_prox(x0));
%     ub = [];
%     ENOB_budget = abc.ENOB_prox(x0);
    energy_budget = abc.energy_prox(x0);
%     options = optimoptions(@fmincon,'Algorithm','active-set','OptimalityTolerance',1e-21, 'StepTolerance', 1e-21, 'ConstraintTolerance', 1e-21,'FunctionTolerance', 1e-30, 'MaxIterations', 10e5, 'MaxFunctionEvaluations', 1e5);
%     options = optimoptions(@fmincon,'Algorithm','interior-point','OptimalityTolerance',1e-21, 'StepTolerance', 1e-21, 'ConstraintTolerance', 1e-15,'FunctionTolerance', 1e-30, 'MaxIterations', 1e5, 'MaxFunctionEvaluations', 1e5);
    options = optimoptions(@fmincon,'Algorithm','sqp','OptimalityTolerance',1e-21, 'StepTolerance', 1e-21, 'ConstraintTolerance', 1e-15,'FunctionTolerance', 1e-30, 'MaxIterations', 1e5, 'MaxFunctionEvaluations', 1e5);
    
    %options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
    k
    x = fmincon(@abc.SNDR_prox,x0,A,b,Aeq,beq,lb,ub,@abc.energy_constraint, options);
%     x = fmincon(@abc.energy_prox,x0,A,b,Aeq,beq,lb,ub,@abc.ENOB_constraint, options)
    
    norm = x;
    norms(k,:) = norm;
    %x = fmincon(@MSE,x0,A,b,Aeq,beq,lb,ub,@power_constraint)
    
    ENOB = [ENOB abc.ENOB_prox(x)];
    energy = [energy abc.energy_prox(x)];
end

% best_k = find(energy == min(energy))
best_k = find(ENOB == max(ENOB))
norms
toc
