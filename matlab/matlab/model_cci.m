    %----------------------------------------------------------------------
% Model for Channel Charge Injection
%
% This function models the resulting Error Voltage due to CCI
%
% dVcci = model_cci(W,L,Cox,Vth,Ch,Xfrac,bs,Vdd)
%
% dVcci		vector containing error voltage due to cci
%
% W 		device width
% L 		device length
% Cox 		oxide capacitance
% Vth		threshold voltage
% Ch		holding capacitance
% Xfrac 	fraction of charge injected (0 to 1)
% bs		bootstrap factor
% Vdd		supply voltage vector
%----------------------------------------------------------------------

function dVcci = model_cci(W,L,Cox,Vth,Ch,Xfrac,bs,Vdd)

	% assuming bootstrapping, since Vgs = Vg - Vs = (Vdd + bs*Vi) - (Vi)
	% dVcci = (-1*W*L*Cox*Xfrac/Ch)*( Vdd + Vdd*(1-bs) - Vth)

	p = Vdd;										% parameter
	len = length(p);								% total number of steps

	for n = 1:len

		z = (-1*W*L*Cox*Xfrac/Ch)*(Vdd(n) + Vdd(n)*(1-bs) - Vth);

		if (n==1)									% think of this as a do
			dVcci = z;
		end

		if (len==1)									% no parametrization, single run
			break;							
		else										% with parametrization, parametric run
			if (n>1)
				dVcci = vertcat(dVcci, z);			% append vector containing current parameter n
			end
		end
	end

	dVcci(dVcci>0) = 0;								% no CCI when Vgs < Vth

end

