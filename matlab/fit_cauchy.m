function [a, b] = fit_cauchy(buffy)
    buf = histogram(buffy, 60, 'Normalization', 'pdf');
%     buf = histcounts(buffy, 60, 'Normalization', 'pdf');
    
    x = buf.BinEdges(2:end);
    y = buf.Values;
    myfittype = fittype('(b/pi)/(b^2 + (x-a)^2)',...
        'dependent',{'y'},...
        'independent',{'x'})

    options = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [1 1]);
    myfit = fit(x',y',myfittype, options);
%     plot(myfit,x,y)
    close(buf);
    a = myfit.a;
    b = myfit.b;
end