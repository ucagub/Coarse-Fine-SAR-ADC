samples = 1e3;
N = 8;
mismats = 0.008;
Cu = (0.008*sqrt(1e-15)./mismats).^2;
n_total = 2^N;
% n_up = 1;
% n_down = n_total - n_up;
vari = zeros(1,2^N-1);
tic
parfor i = 1:2^N-1
    n_up = i;
    n_down = n_total - n_up;

    buff1 = add_mismatch2(Cu*n_up, mismats, ones(1,samples));
    buff2 = add_mismatch2(Cu*n_down, mismats, ones(1,samples));   
    buff_res = buff1./(buff1 + buff2);
    %maan(i) = mean(buff_res);
    vari(i) = var(buff_res);
end

vari = [0 vari];
stem(vari)
% buff_dnl = zeros(1,2^N-1);
% for i = 1:length(buff_dnl)
%     buff_dnl(i) = vari(i+1) - vari(i);
% end
% toc
% stem(buff_dnl)