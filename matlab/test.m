Vref = 1;
SCA1_array = [4 2 1 1 2 2 2 1 1];
SCA2_array = [4 2 1 1 2 2 2 1 1];

%           [4 2 1 1 2 2 2 1 1]
SCA1_code = [0 1 0 1 0 0 1 0 0];
SCA2_code = [0 1 0 1 0 0 1 0 1];

%           [4 2 1 1 2 2 2 1 1]
SCA1_conn = [0 0 0 0 1 0 0 1 0];
SCA2_conn = [0 0 0 0 0 1 1 1 0];

SCA1_bound = SCA1_code*SCA1_array' / sum(SCA1_array);
SCA2_bound = SCA2_code*SCA2_array' / sum(SCA2_array);

Q1 = (SCA1_bound-Vref*SCA1_code)*SCA1_conn';
Q2 = (SCA2_bound-Vref*SCA2_code)*SCA2_conn';
Qtot = Q1 + Q2;

Vout = Qtot / ((SCA1_bound-Vref*SCA1_code).*SCA1_array*SCA1_conn' + (SCA2_bound-Vref*SCA2_code).*SCA2_array*SCA2_conn');

% A = Cup1
% B = Cup2
% C = Cdown1
% D = Cdown2

A = SCA1_array.*SCA1_conn*SCA1_code' ;
C = sum(SCA1_array.*SCA1_conn) - SCA1_array.*SCA1_conn*SCA1_code';
B = SCA2_array.*SCA2_conn*SCA2_code' ;
D = sum(SCA2_array.*SCA2_conn) - SCA2_array.*SCA2_conn*SCA2_code';

X = SCA1_bound;
Y = SCA2_bound;

Vout = ( A*(X-Vref)+C*X+B*(Y-Vref)+D*Y+Vref*(A+B) ) / (A+B+C+D);
Vout