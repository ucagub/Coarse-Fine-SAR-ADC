
res = 10;
k = 7;
dac_k = 7;
fine_dac_type = 'CS_DAC';

coarse_dac_type = 'CS_DAC';

tic
samples = 1e2;
sam_p = 5;

buff_curve = zeros(sam_p,sam_p);

coarse_Cu = linspace(10e-15, 70e-15, sam_p);
fine_Cu = linspace(10e-15, 22e-15, sam_p);
coarse_noise = 0.2e-6;
fine_noise = 0.2e-6;

%buffs for cauchy fit

% c_load = linspace(10e-6, 3e-3, sam_p);
c_load = .4e-15;
% droop = linspace(10e-6, 3e-3, sam_p);
droop = 0;
time_elapsed = 0;
estimated_time = 2.2*sam_p^2*10;
print_time(estimated_time);
for k = 0:9
    buff_a = zeros(1, sam_p);
    % buff_b = zeros(1, sam_p);
    
    for j = 1:sam_p
        for z = 1:sam_p
            estimated_time_left = estimated_time - time_elapsed;
            print_time(estimated_time_left);
            buff_fine_Cu = fine_Cu(z);
            buff_coarse_Cu = coarse_Cu(j);
            buf_droop = droop;
        %     buf_c_load = c_load(j);
            buf_c_load = c_load;
            tic
            k
            buffy = zeros([1 samples]);
            parfor i = 1:samples
                a = ADC(res, k, k, coarse_dac_type, buff_coarse_Cu, fine_dac_type, buff_fine_Cu, .1250e-6, .0286e-6, .5e-15, 1.5e-15, buf_droop);
                a.disp_ENOB;
                buffy(i) = a.SNDR;
            end
            %cauchy fit part
            [a, b] = fit_cauchy(buffy);
            buff_curve(j,z) = a;
            toc
            time_elapsed = toc + time_elapsed;

        end
    end
    % plot(droop, buff_a)
    % plot(c_load, buff_a)

    [X, Y] = meshgrid(coarse_Cu,fine_Cu);
%     figure;
%     surf(X,Y,buff_curve)
%     ylabel('fine Cu')
%     xlabel('coarse Cu')
%     zlabel('ENOB')

    toc


    %house keeping
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

    sf = fit([x', y'],z','poly23');
    label = ['cs-cs-3d-200ksps-loaded-with-noise-SNDR/coarse_' coarse_dac_type 'fine_' fine_dac_type 'k_' num2str(k) '.mat'];
    save(label)
    label_var = ['cs-cs-3d-200ksps-loaded-with-noise-SNDR/coarse_' coarse_dac_type 'fine_' fine_dac_type 'k_' num2str(k) 'sf' '.mat'];
    save(label_var, 'sf');
    close;
    figure;
    plot(sf,[x',y'],z');
    label = ['k=' num2str(k)];
    title(label);
    figure;
end

