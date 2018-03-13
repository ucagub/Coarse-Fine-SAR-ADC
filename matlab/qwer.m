iter = 1e2;
samples = 1e4;
%mismats = linspace(0.001, .05, iter);
mismats = 0.008;
%Cu = 1e-15;
Cu = (0.008*sqrt(1e-15)./mismats).^2;


n_total = 2;
n_up = 1;
n_down = n_total - n_up;

%histogram(buff1, 20)

%mean(buff1)
%sqrt(var(buff1))

maan = zeros(1,length(mismats));
stdv = zeros(1,length(mismats));
tic
parfor i = 1:length(mismats)
    buff1 = add_mismatch2(Cu(i)*n_up, mismats(i), ones(1,samples));
    buff2 = add_mismatch2(Cu(i)*n_down, mismats(i), ones(1,samples));   
    buff_res = buff1./(buff1 + buff2);
    maan(i) = mean(buff_res);
    stdv(i) = sqrt(var(buff_res));
end
toc
% loglog(mismats, stdv)
%plot(log10(mismats), log10(stdv))
% p = polyfit(log10(mismats),log10(stdv),1)
% buffy = polyval(p,log10(mismats));
% 
% plot(log10(mismats),log10(stdv),log10(mismats),buffy)
% 
% plot(mismats,stdv,mismats,10.^buffy)
% p = polyfit(mismats,stdv,1)
% buffy = polyval(p,mismats);
% 
% plot(mismats,stdv,mismats,buffy)

plot(mismats, stdv)
% figure 
% loglog(mismats, stdv)




