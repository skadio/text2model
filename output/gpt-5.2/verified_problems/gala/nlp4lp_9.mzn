% Upper bound on E[Z^4] given E[Z] and E[Z^2] for Z in {0,1,...,K}
% Linear program over probabilities p_k.

int: K;                          % support size parameter (Z takes values 0..K)
float: ExpectedZ;                % given E[Z]
float: ExpectedZSquared;         % given E[Z^2]

% Note: Input may also contain P (example given), but it is not needed for this LP.
array[1..K] of float: P;         % accepted (unused); allows provided data to parse

set of int: S = 0..K;

% Decision variables: probabilities
array[S] of var float: p;

% Basic probability constraints
constraint forall(k in S)(p[k] >= 0.0);
constraint sum(k in S)(p[k]) = 1.0;

% Moment constraints
constraint sum(k in S)(int2float(k) * p[k]) = ExpectedZ;
constraint sum(k in S)((int2float(k*k)) * p[k]) = ExpectedZSquared;

% Objective: maximize fourth moment
var float: E4 = sum(k in S)((int2float(k*k*k*k)) * p[k]);

solve maximize E4;

output [
  "K = ", show(K), "\n",
  "p = ", show(p), "\n",
  "E[Z^4] (upper bound) = ", show(E4), "\n"
];