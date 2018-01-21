function [c,ceq] = con(x)
   c = [];
   ceq(1) = x(1)^2 + x(2)^2 + x(1)^4;
   ceq(1) = x(2)^2 + x(2)^2 + x(2)^4;
end