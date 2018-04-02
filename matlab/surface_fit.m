cs_ENOB = {};
for k = 5:5
    label = ['cs_cs_ENOB3d/coarse_CS_DACfine_CS_DACk_' num2str(k) '.mat'];
    load(label)
    tot_samp = size(X,1)^2;
    x_samp = size(X,1);
    x = zeros(1,tot_samp);
    y = zeros(1,tot_samp);
    z = zeros(1,tot_samp);
    %i is y-axis sweep
    for i = 1:x_samp
        %j is x-axis sweep
        for j = 1:x_samp
            x((i-1)*x_samp+j) = X(i,j);
            y((i-1)*x_samp+j) = Y(i,j);
    %         x(i*j) = X(j,i);
    %         y(i*j) = Y(j,i);
            z((i-1)*x_samp+j) = buff_curve(j,i);
    %         z(i*j) = buff_curve(i,j);
        end
    end

    sf = fit([x', y'],z','poly22');
    cs_ENOB{k} = sf;
    figure;
    plot(sf,[x',y'],z');
    set(gca,'fontsize',30)
    xlabel('fine mismatch','FontSize', 30)
    ylabel('coarse mismatch','FontSize', 30)
    zlabel('ENOB','FontSize', 30)
    title(['ENOB = f(coarse-mismatch, fine-mismatch) at k=' num2str(k)],'FontSize', 30)
end

% surf(X,Y,buff_curve)
