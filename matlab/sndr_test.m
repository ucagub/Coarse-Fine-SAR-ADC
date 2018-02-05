ENOB = [];
mismatch = [];
iter = 1e3;
for j  = 0.01:0.01:0.1 
    j
    tic
    %iter = 1e1;
    ENOB = [ENOB get_ENOB(iter, 8, 'CS_DAC', j)];
    mismatch = [mismatch j];
    toc
end

for i  = 0.15:0.05:0.5 
    i
    tic
    %iter = 1e1;
    ENOB = [ENOB get_ENOB(iter, 8, 'CS_DAC', i)];
    mismatch = [mismatch i];
    toc
end
figure('Name', 'ENOBvsMismatch_8bit')
plot(mismatch, ENOB)
xlabel('mismatch');
ylabel('ENOB');
savefig('ENOB_hist/ENOBvsMismatch_8bit.fig');
