%t = [0:0.01:1]';
%f = 1;
%input = sin(2*pi*f*t);
%y = sin(t);
%plot(output)
%{
t = 0.2 * [0:49]';
x = sin(t);
y = 10*sin(t);
tsample = 
%}

%f = 10/4;
%t = [0:0.001:2*pi]';
%x = 10*sin(t + pi);
%y = 0.5*sin(2*pi*f*t + pi/2) + 0.5;
StopTime = .1;
t = [0:0.0001:StopTime]';

ramp = (1/StopTime)*t;
input.time = t;
input.signals.values = [ramp];
input.signals.dimensions = 1;

C = 1e-15;
%mismatch = [0 C*normrnd(0,.1,[1,9])];
mismatch = zeros(1,10);
%plot(output.signals.values)
%tsample = [zeros([size(t,1) 1]) t];
