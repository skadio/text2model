% Parameters
int: K;
array[1..K] of float: P;
float: ExpectedZ;
float: ExpectedZSquared;

% Variables
var float: E_Z4;

% Constraints
constraint E_Z4 = sum(i in 1..K)(i*i*i*i*P[i]);
constraint sum(i in 1..K)(i*P[i]) = ExpectedZ;
constraint sum(i in 1..K)(i*i*P[i]) = ExpectedZSquared;

% Objective
solve maximize E_Z4;