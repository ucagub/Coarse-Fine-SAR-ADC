%----------------------------------------------------------------------
% Model for Clock Feedthrough
%
% This function models the resulting Error Voltage due to CF
%
% dVcf = model_cf(W,Lov,Cox,Vth,Ch,bs,Vdd)
%
% dVcf		vector containing error voltage due to cf
%
% W 		device width
% Lov 		overlap length (also known as Xd)
% Cox 		oxide capacitance
% Vth		threshold voltage
% Ch		holding capacitance
% bs		bootstrap factor
% Vdd		supply voltage vector
%----------------------------------------------------------------------

function dVcf = model_cf(W,Lov,Cox,Vth,Ch,bs,Vdd)

	% since at turn-off, Vg = Vi*(1-bs) + Vth with Vi = [0:Vdd]
	% dVcf = -1*[ W*Lov*Cox / (W*Lov*Cox + Ch) ]*[ Vdd*(1-bs) + Vth ]

	p = Vdd;										% parameter
	len = length(p);								% total number of steps

	for n = 1:len

		z = -1*( W*Lov*Cox / (W*Lov*Cox + Ch) )*( Vdd(n)*(1-bs) + Vth )

		if (n==1)									% think of this as a do
			dVcf = z;
		end

		if (len==1)									% no parametrization, single run
			break;							
		else										% with parametrization, parametric run
			if (n>1)
				dVcf = vertcat(dVcf, z);			% append vector containing current parameter n
			end
		end
	end

end

