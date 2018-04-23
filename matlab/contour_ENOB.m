a = DAC_fns(3, 2e-12, 9.6);
sam_p = 20;
% coarse_Cu = linspace(10e-15, 70e-15, sam_p);
fine_Cu = linspace(10e-15, 22e-15, sam_p);
Constant_E = zeros(1,sam_p);
for j = 1:sam_p
    Constant_E(j) = a.energy_prox([10e-15 fine_Cu(j)]); 
end

% Constant_E = a.energy_prox([10e-15,10e-15]);

buff_coarse = zeros(1,sam_p);
contour = {};
for j = 1:sam_p
    for i = 1:sam_p
        buff_coarse(i) = a.get_coarse_Cu(Constant_E(j), fine_Cu(i));
    end
    contour{j} = buff_coarse;
    
end
figure;
for j = 1:sam_p
%     figure;
    plot(fine_Cu, contour{j});
    hold on
end
xlim([10e-15 22e-15])
ylim([10e-15 70e-15])
xlabel('fine Cu', 'FontSize', 30)
ylabel('coarse Cu', 'FontSize', 30)
label = ['constant energy lines k=' num2str(k)];
title(label, 'FontSize', 30)
set(gca, 'FontSize', 30)
hold off