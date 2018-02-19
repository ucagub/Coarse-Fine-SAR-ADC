iter = 10000;
average = [];

tic
for n = 1:100

    match = zeros(1,iter);

    for q = 1:iter
        bdays = [];
        for i = 1:n
            bdays = [bdays round(rand*365)];
        end

        for i = 1:n
            for k = i+1:n
                if bdays(i) == bdays(k)
                    match(q) = 1;
                end
            end
        end
    end

    average = [average mean(match)];
end

toc