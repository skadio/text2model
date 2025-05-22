% Parameters
int: K;
array[1..K] of float: P;
float: ExpectedZ;
float: ExpectedZSquared;

% Variables
var 0..1000000: E_Z_4;

% Constraints
constraint forall(k in 1..K) (E_Z_4 >= k^4 * P[k]);
constraint sum(k in 1..K) (k * P[k]) = ExpectedZ;
constraint sum(k in 1..K) (k^2 * P[k]) = ExpectedZSquared;

% Objective
solve maximize E_Z_4;