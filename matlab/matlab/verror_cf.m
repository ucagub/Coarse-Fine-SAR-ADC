%----------------------------------------------------------------------
% Verror due to CF
%
% This script demonstrates the Error Voltage due to CF as Vdd varies
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% adc values
%----------------------------------------------------------------------

	Vdd = [0:0.1:1];
	N = 8;

	W = 1e-6;
	Lov = 20e-9;
	Cox = 14.448e-3;
	Vth = 0.5;
	Ch = 1e-12;
	bs = 0.99;

	% each row corresponds to one line
	plot_info = {
		sprintf('W=%1.2e',W);						
		sprintf('Lov=%1.2e',Lov);
		sprintf('Cox=%1.2e',Cox);
		sprintf('Vth=%0.3f',Vth);
		sprintf('Ch=%1.2e',Ch);
		sprintf('bs=%0.3f',bs);
	};

	Verr = [];

	for i = 1: length(Vdd);

		d = Vdd(i) / (2^N);

		val = model_cf(W,Lov,Cox,Vth,Ch,bs,Vdd(i)) / d;
	
		Verr = horzcat(Verr,val);

	end

	figure();

		clf;

		ax_outer = axes('Position',[0 0 1 1],'Visible','off');		% where the text + inner plot will be placed
		ax_inner = axes('Position',[0.11 0.11 .65 .8]);				% [left bottom width height]

		axes(ax_outer); 											% set current axes to outer
		text(0.8,0.7,plot_info,'FontWeight','bold');				% insert text: [x y]

		axes(ax_inner);

		hold on;
		grid on;

		plot(Vdd,Verr,'-bo','LineWidth',3);

		axis( [ min(Vdd) max(Vdd) min(Verr) max(Verr) ] );
		
		xlabel('Vdd');
		ylabel('V_{error} normalized to [1 LSB V]');
		title('V_{error} due to CF with Vdd','FontWeight','bold','FontSize',16);

	clc;