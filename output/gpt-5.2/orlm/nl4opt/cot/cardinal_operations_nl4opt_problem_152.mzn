% Parameters (with values embedded)
int: reqA = 150;
int: reqD = 300;
int: maxE = 400;

int: A_A = 8;   int: A_D = 6;  int: A_E = 10; int: A_K = 4;
int: B_A = 15;  int: B_D = 2;  int: B_E = 20; int: B_K = 12;

% Variable bounds (derived from meeting Vitamin A and D requirements with nonnegative cups)
int: UBx = 50;   % from 6*x >= 300 => x >= 50 (used as safe upper bound)
int: UBy = 150;  % safe upper bound

% Variables
var 0..UBx: x; % cups of drink A
var 0..UBy: y; % cups of drink B
var 0..(A_K*UBx + B_K*UBy): totalK;

% Constraints
constraint A_A * x + B_A * y >= reqA;
constraint A_D * x + B_D * y >= reqD;
constraint A_E * x + B_E * y <= maxE;

constraint totalK = A_K * x + B_K * y;

% Objective
solve minimize totalK;