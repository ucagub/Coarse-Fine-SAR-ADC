function energy = CS_energy(obj, Cu_array)
    %input: Cu_array = [coarse_Cu fine_Cu]
    energy = sum(obj.cs_coarse_energy*Cu_array(1) + obj.cs_fine_energy*Cu_array(2));
    
end