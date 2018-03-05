tic
a = normrnd(0.5, 0.2, [1 1e7]);
a = trim(a);
[mhat, shat] = normfit(a, 0.05)
% figure;
% edges = [0:0.005:1];
% histogram(a, edges)
toc

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