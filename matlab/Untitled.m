data = csvread('inputparasiticcap.csv',1);
Xdata = data(:,1);
Ydata = data(:,2);
sampley = [Ydata(1) Ydata(250) Ydata(450) Ydata(901)];
samplex = [Xdata(1) Xdata(250) Xdata(450) Xdata(901)];