% Parameters
int: K;
array[1..K] of float: P;
float: ExpectedZ;
float: ExpectedZSquared;

% Variables
var float: ExpectedZ4;

% Constraints
constraint ExpectedZ = sum(k in 1..K)(k*P[k]);
constraint ExpectedZSquared = sum(k in 1..K)(k*k*P[k]);
constraint ExpectedZ4 >= sum(k in 1..K)(k*k*k*k*P[k]);

% Objective
solve maximize ExpectedZ4;