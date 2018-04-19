for k = 1:9
    label = ['coarse_CS_DACfine_CS_DACk_' num2str(k)];
    load(label);
    [X, Y] = meshgrid(fine_Cu,coarse_Cu);
    figure;
    surf(X,Y,buff_curve)
    ylabel('coarse Cu', 'FontSize', 30)
    xlabel('fine Cu', 'FontSize', 30)
    zlabel('ENOB', 'FontSize', 30)
    label = ['ENOB = f(fine-Cu, coarse-Cu) at k=' num2str(k)];
    title(label, 'FontSize', 30)
    set(gca, 'FontSize', 30)
end