tic
% k=2
sam_p = 40;
coarse_Cu = linspace(10e-15, 70e-15, sam_p);
fine_Cu = linspace(10e-15, 22e-15, sam_p);

[coarse_Cu fine_Cu] = meshgrid(coarse_Cu, fine_Cu);
fine_Cu = gpuArray(fine_Cu);
coarse_Cu = gpuArray(coarse_Cu);
min_energy_k = zeros(1,9);
%coarse fine
min_Cus = zeros(9,2);
ENOB_constraint = 9.1
for k = 1:9
    
    min_energy = 1;
    min_coarse_Cu = 0;
    min_fine_Cu = 0;
    a = DAC_fns(k, 0, 0);

    buff_energy = arrayfun(@(x,y)(2.*x+2.*y), coarse_Cu,  fine_Cu);
%     buff_energy = arrayfun(@a.energy_prox_v2, coarse_Cu,  fine_Cu);
    buff_ENOB = arrayfun(@a.ENOB_prox_v2, coarse_Cu, fine_Cu);
%     for j =1:sam_p
%         for i = 1:sam_p
% %             buff_energy = a.energy_prox([coarse_Cu(i) fine_Cu(j)]);
% %             buff_ENOB = a.ENOB_prox([coarse_Cu(i) fine_Cu(j)]);
%             if (buff_energy(i,j) < min_energy) & (buff_ENOB(i,j) > ENOB_constraint)  
%                 min_energy = buff_energy(i,j);
%                 min_coarse_Cu = coarse_Cu(i,j);
%                 min_fine_Cu = fine_Cu(i,j);
%             end
%         end
%     end
%     min_energy_k(k) = min_energy;
%     min_Cus(k,:) = [min_coarse_Cu min_fine_Cu];
end

best_k = find(min_energy_k == min(min_energy_k)) 

toc
