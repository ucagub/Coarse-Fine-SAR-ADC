x = M(:,4);
y = M(:,2);

% myfittype = fittype('plsb*0.0009^2/x^2',...
%         'dependent',{'y'},...
%         'independent',{'x'})
% 
% options = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [10e-15]);
% myfit = fit(x,y,myfittype, options)
% plot(myfit,x,y)

% scatter(x,y)
% hold on
% p = polyfit(x,y,2);
% x_fit = linspace(x(1), x(end), 100);
% y_fit = polyval(p, x_fit);
% 
% plot(x_fit,y_fit);
% hold off

myfit = fit(x,y,'exp2')
plot(myfit,x,y)