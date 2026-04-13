% Upper bound on E[Z^4] given E[Z] and E[Z^2]
% Z takes values 0..K with probabilities p[k]

% Parameters
int: K;
float: ExpectedZ;
float: ExpectedZSquared;

% Decision variables: probabilities
array[0..K] of var float: p;

% Fourth moment
var float: EZ4;

% Constraints
constraint forall(k in 0..K) (p[k] >= 0.0);
constraint sum(k in 0..K) (p[k]) = 1.0;

constraint sum(k in 0..K) (int2float(k) * p[k]) = ExpectedZ;
constraint sum(k in 0..K) (int2float(k*k) * p[k]) = ExpectedZSquared;

constraint EZ4 = sum(k in 0..K) (int2float(k*k*k*k) * p[k]);

% Objective: maximize E[Z^4]
solve maximize EZ4;

output [
  "EZ4 = ", show(EZ4), "\n",
  "p = ", show(p), "\n"
];