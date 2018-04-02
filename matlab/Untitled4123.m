x = [0:10];
x = 10.^x;

y = x.^-2;

loglog(x, y)
hold on
y = x.^2;
loglog(x, y)
hold off
