N               = 8;
f_sampling      = 1e8;
f_input         = 100;
f_clk           = 1e3;
Vdd             = 1;
clock_duty      = 50;
droop           = 1e-9;

time            = 2/f_input;   
hold_value      = 0;
hold_counter    = 0;
droop_total = 0;



W   = 60e-9;
L   = 130e-9;
Lov = 20e-9;
Cox = 14.448e-3;
Vth = 0.5;
Ch  = 1e-9;
Xfrac = 0.5;
bs  = 0.99;
Ron = 10e3;

output  = zeros(1,time*f_sampling + 1);
t       = [0: 1/f_sampling: time];
input   = 0.5*(sin(2*pi*f_input*t)+1);
%input   = .5*(square(2*pi*f_input*t,50)+1);
clk     = .5*(square(2*pi*f_clk*t,clock_duty)+1);

error_cci   = model_cci(W,L,Cox,Vth,Ch,Xfrac,bs,Vdd) / (2^N);
error_cf    = model_cf(W,Lov,Cox,Vth,Ch,bs,Vdd)  / (2^N);


output(1) = 0;
for k = 2:length(t);
   if clk(k) == 1
       output(k) =  output(k-1) + (( input(k-1) - output(k-1) ) / Ron )*(1/f_sampling)/Ch;
       droop_total = 0;
   else
%        if hold_value-hold_counter*leakage > 0
%            output(k) = hold_value-hold_counter*leakage;
%        else
%            output(k) = 0;
%        end

%  + error_cci + error_cf
       if output(k-1) - droop*(1/f_sampling)/Ch > 0
           output(k) = output(k-1) - droop*(1/f_sampling)/Ch;
       else
           output(k) = 0;
       end
   end
end

figure;
hold on;
plot(t,output);
plot(t,input);
%plot(t,clk);
hold off;
figure;
sinad(output, f_input);

