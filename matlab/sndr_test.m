ENOB = [];
mismatch = [];
iter = 1e1;
dac_type = 'CS_DAC';
%j=0;
for j  = 0.01:0.01:0.1 
    j
    tic
    ENOB = [ENOB get_ENOB(iter, 8, dac_type, j)];
    mismatch = [mismatch j];
    toc
end

for i  = 0.15:0.05:0.5 
    i
    tic
    ENOB = [ENOB get_ENOB(iter, 8, dac_type, i)];
    mismatch = [mismatch i];
    toc
end
figure('Name', ['ENOBvsMismatch_8bit_' dac_type])
plot(mismatch, ENOB)
xlabel('mismatch');
ylabel('ENOB');
%savefig('ENOB_hist/8bit_multistep_CS/ENOBvsMismatch_8bit_multistep_CS.fig');
