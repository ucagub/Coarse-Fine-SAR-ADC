[X, Y] = meshgrid(coarse_Cu,fine_Cu);
Xq = linspace(10e-15,70e-15,5);
Yq = linspace(10e-15, 22e-15,20);
[Xq,Yq] = meshgrid(Xq,Yq);
Vq = interp2(X,Y,buff_curve,Xq,Yq);
figure;
% surf(X,Y,buff_curve)
surf(Xq,Yq,Vq);
ylabel('fine Cu')
xlabel('coarse Cu')
zlabel('ENOB')