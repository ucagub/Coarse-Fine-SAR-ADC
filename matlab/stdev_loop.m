%final_mean = zeros(1,255); 
%for j = 1:100
    iter = 1000;
    buff = zeros(iter, 255);

    for i = 1:iter
        a = JS_DAC('asfd');
        buff(i,:) = a.DNL;
    end

    % code_var = zeros(1,255);
    % for i = 1:255
    %     code_var(i) = var(buff(:,i));
    % end
    % code_stdev = sqrt(code_var);
    % 
    % figure;
    % plot(code_stdev)

    code_mean = zeros(1,255);
    for i = 1:255
        code_mean(i) = mean(buff(:,i));
    end
    
 %end
figure;
plot(code_mean)
