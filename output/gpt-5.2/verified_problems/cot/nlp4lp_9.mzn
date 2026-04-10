% Parameters
int: K;
set of int: KK = 0..K;

float: ExpectedZ;
float: ExpectedZSquared;

% Variables
array[KK] of var float: p;

var float: EZ4;

% Constraints
constraint forall(k in KK) (p[k] >= 0.0);
constraint sum(k in KK) p[k] = 1.0;

constraint sum(k in KK) (int2float(k) * p[k]) = ExpectedZ;
constraint sum(k in KK) (int2float(k*k) * p[k]) = ExpectedZSquared;

constraint EZ4 = sum(k in KK) (int2float(k*k*k*k) * p[k]);

% Objective
solve maximize EZ4;