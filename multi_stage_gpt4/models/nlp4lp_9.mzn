% Parameters
int: K; % Number of terms in the sequence
array[1..K] of float: P; % Coefficients of the linear combination
float: ExpectedZ; % Expected value of Z
float: ExpectedZSquared; % Expected value of Z squared

% Variables
var float: E_Z_4; % Fourth moment of Z

% Constraints

% Constraint for the expected value of Z
constraint sum(k in 1..K)(k * P[k]) = ExpectedZ;

% Constraint for the expected value of Z squared
constraint sum(k in 1..K)(k^2 * P[k]) = ExpectedZSquared;

% Constraint for the fourth moment of Z
constraint E_Z_4 = sum(k in 1..K)(k^4 * P[k]);

% Constraint for the upper bound of the fourth moment of Z
constraint E_Z_4 <= ExpectedZSquared^2;

% Objective
solve maximize E_Z_4;