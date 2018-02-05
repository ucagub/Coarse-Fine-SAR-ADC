%Fnp,cap is approximately equal to 1.2


n = 3:1:8;
f1 = 1./(2.^n-1);
f2 = [];
for n = 3:1:8
   x = 0;
   for k = 0:1:n-2
       x = x + 1/(2^(n-k)-1);
   end
   f2 = [f2, x];
end
f = 2.*(f1 + f2);
n = 3:1:8;
plot(n,f,'-s')
xlabel('Resolution N')
ylabel('Fnp,cap')