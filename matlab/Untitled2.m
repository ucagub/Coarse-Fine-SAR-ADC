proc_constant = 0.05*sqrt(1e-15);
samples = 1e6;
b1 = 1;
b2 = 1;
buff = 2^7;
%Cu = 1e-10;
buffx = [-14:0.01:-9];
Cu = 10.^(buffx);
%Cu = 10^-14;
buffy = zeros(1,length(Cu));
%i = 1;
tic
parfor i = 1:length(Cu)
    
    sigma_Cu = proc_constant/sqrt(Cu(i));


    sigma = Cu(i)*buff*sigma_Cu/sqrt(buff);
    mean1 = Cu(i)*buff;
    mean2 = Cu(i)*buff;
    a = normrnd(mean1, sigma, [1 samples]);
    b = normrnd(mean2, sigma, [1 samples]);
%     varhat = var(a);
%     stdevhat = sqrt(varhat)
    % meanhat = mean(a)
    c = a./(b+a);
    [muhat, shat] = normfit(c,1e-6)
    buffy(i) = shat; 
    %meanhat = mean(c);

    %stdnormalized = sqrt(var((Cu-a)/Cu));
end
figure;
loglog(Cu, buffy)
figure;
plot(log10(Cu), log10(buffy))
figure;
a = log10(Cu);
b = log10(buffy);
p = polyfit(a, b, 1)
y = polyval(p, buffx);
plot(buffx, y);
toc
    %c = trim(c);
%     vari = c;
%     [muhat, shat] = normfit(vari,1e-6)
%     edges = linspace(0, 1, 100);
%     histogram(vari, edges)
%     title('actual')
%     figure
%     
%     d = normrnd(muhat, shat, [1 samples]);
%     histogram(d, edges)
%     title('reconstruction')
    
    
function y = trim(a)
    for i = 1:size(a)
        if a(i) <= -1.5
            a{i} = -1.5
        elseif a(i) >= 2.5
            a(i) = 2.5
        end
    end
    y = a;
end