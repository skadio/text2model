% Parameters
int: K;                          % Maximum value of random variable Z (support is 0..K)
array[1..K] of float: P;         % Input parameter (not used in this LP formulation)

float: ExpectedZ;                % Given first moment E[Z]
float: ExpectedZSquared;         % Given second moment E[Z^2]

% Variables (probability masses)
var float: p0;                   % p_0
array[1..K] of var float: p;     % p_1..p_K

var float: expectedZ4;           % E[Z^4] (objective)

% Constraints: valid probability distribution
constraint p0 >= 0.0;
constraint forall(k in 1..K)(p[k] >= 0.0);
constraint p0 + sum(k in 1..K)(p[k]) = 1.0;

% Moment constraints
constraint sum(k in 1..K)(k * p[k]) = ExpectedZ;
constraint sum(k in 1..K)((k * k) * p[k]) = ExpectedZSquared;

% Fourth moment definition
constraint expectedZ4 = sum(k in 1..K)((k * k * k * k) * p[k]);

% Objective: maximize E[Z^4]
solve maximize expectedZ4;