Vref = 1;
N = 10;
k = 7;
Plsb = 1e-6;
Pbudget = 175*Plsb;
lsb = Vref/2^N;;

x0 = [0,0];
x0(1) = Plsb;
x0(2) = sqrt(((Pbudget/(Plsb*lsb^2) - (N-k)/x0(1)^2)^-1)*k);
[a, b]= power_constraint(x0)
A = [];
b = [];
Aeq = [];
beq = [];
lb = [0 0];
ub = [];

options = optimoptions(@fmincon,'Algorithm','interior-point','OptimalityTolerance',1e-12, 'StepTolerance', 1e-12, 'ConstraintTolerance', 1e-12, 'MaxIterations', 5e3)
%options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

x = fmincon(@MSE,x0,A,b,Aeq,beq,lb,ub,@power_constraint, options)
%x = fmincon(@MSE,x0,A,b,Aeq,beq,lb,ub,@power_constraint)

mse = MSE(x)