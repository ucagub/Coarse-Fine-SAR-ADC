% figure;
% x = [5:1e-2:10];
% var = 0.5;
% %fun = @(a) (a/var)*exp(-a^2/(2*var));
% a = 10;
% b = -1;
% fun = @(ax) ((a + b*ax)/var)*exp(-(a + b*ax)^2/(2*var))

y = arrayfun(fun,x);% + 0.02*randn(1,length(x));
% plot(x,y)
% figure;
% a = raylrnd(1,1,1e4);
% b = histogram(a, 'Normalization', 'pdf')
% 
% x = linspace(1,100);  
% y = 5 + 7*log(x);
buf = histogram(buffy, 40, 'Normalization', 'pdf');
x = buf.BinEdges(2:end);
y = buf.Values;
myfittype = fittype('((10 - x)/var)*exp(-(10 - x)^2/(2*var))',...
    'dependent',{'y'},...
    'independent',{'x'})

options = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [1]);

%options = fitoptions('gauss2', 'StartPoint', [9.5 -1 .01]);
%options = fitoptions('gauss2');

myfit = fit(x',y',myfittype, options)
% plot(x,y)  

plot(myfit,x,y)

%a + b*x