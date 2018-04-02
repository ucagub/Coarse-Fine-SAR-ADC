
sam_p = 10;
left_edge = 0.002;
right_edge = 0.012;
buff_coarse_mismatch = linspace(left_edge, right_edge, sam_p);
buff_fine_mismatch = linspace(left_edge, right_edge, sam_p);


[X, Y] = meshgrid(buff_coarse_mismatch,buff_fine_mismatch);
surf(X,Y,buff_curve)

ylabel('coarse mismatch')
xlabel('fine mismatch')
zlabel('ENOB')