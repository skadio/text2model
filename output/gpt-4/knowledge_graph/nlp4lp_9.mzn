% Input Data Nomenclature
int: K; % Number of terms in the sequence
array[0..K] of float: P; % Coefficients of the linear combination
float: ExpectedZ; % Expected value of Z
float: ExpectedZSquared; % Expected value of Z squared

% Variables
var float: E_Z_4; % Fourth moment of Z

% Constraints
constraint forall(k in 0..K) (
    ExpectedZ = sum(k * P[k])
);
constraint forall(k in 0..K) (
    ExpectedZSquared = sum(k^2 * P[k])
);

% Objective
solve maximize E_Z_4;

% Output
output ["E[Z^4] = ", show(E_Z_4)];