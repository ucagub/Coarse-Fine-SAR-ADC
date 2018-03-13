buf = histogram(buffy, 60, 'Normalization', 'pdf');
x = buf.BinEdges(2:end);
y = buf.Values;
gaussEqn = 'a*exp(-((x-b)/c)^2)+d';
startPoints = [1 9 1 1];
f1 = fit(x',y',gaussEqn,'Start', startPoints)
plot(f1,x,y)


