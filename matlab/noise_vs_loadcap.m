a = csvread('comparatorfinal (4).csv',1);

x1 = linspace(2.05e-16,6.25e-15, 100);
y1 = interp1q(a(:,6), a(:,3), x1');

plot(a(:,6), a(:,3), 'o', x1, y1)