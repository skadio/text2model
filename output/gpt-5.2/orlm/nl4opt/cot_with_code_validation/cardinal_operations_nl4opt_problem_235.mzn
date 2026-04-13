% Parameters
int: N_A = 13;
int: P_A = 5;
int: VA_A = 6;
int: VD_A = 5;

int: N_B = 8;
int: P_B = 14;
int: VA_B = 6;
int: VD_B = 9;

int: N_min = 220;
int: P_min = 160;
int: VA_max = 350;

% Variables
var 0..10000: kgA;
var 0..10000: kgB;
var 0..(VD_A*10000 + VD_B*10000): totalVD;

% Constraints
constraint N_A*kgA + N_B*kgB >= N_min;
constraint P_A*kgA + P_B*kgB >= P_min;
constraint VA_A*kgA + VA_B*kgB <= VA_max;

constraint totalVD = VD_A*kgA + VD_B*kgB;

% Objective
solve minimize totalVD;