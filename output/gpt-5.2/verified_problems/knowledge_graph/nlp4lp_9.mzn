% Upper bound on E[Z^4] given E[Z], E[Z^2] for Z in {0,1,...,K}
% Data provided in .dzn:
%   int: K;
%   array[0..K] of float: P;              % probabilities p_k (note index 0..K)
%   float: ExpectedZ;                     % E[Z]
%   float: ExpectedZSquared;              % E[Z^2]

include "float.mzn";

int: K;
array[0..K] of float: P;
float: ExpectedZ;
float: ExpectedZSquared;

float: eps = 1e-8;

% Probability constraints
constraint forall(k in 0..K)(P[k] >= 0.0);
constraint abs(sum(k in 0..K)(P[k]) - 1.0) <= eps;

% Moment constraints
constraint abs(sum(k in 0..K)(int2float(k) * P[k]) - ExpectedZ) <= eps;
constraint abs(sum(k in 0..K)((int2float(k)*int2float(k)) * P[k]) - ExpectedZSquared) <= eps;

% Objective: maximize E[Z^4]
var float: EZ4 = sum(k in 0..K)(
  let { float: fk = int2float(k) } in (fk*fk*fk*fk) * P[k]
);

solve maximize EZ4;

output [
  "UpperBound_EZ4 = ", show(EZ4), "\n"
];