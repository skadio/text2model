% Parameters
int: K; % Number of terms in the sequence
array[1..K] of float: P; % Coefficients of the linear combination
float: ExpectedZ; % Expected value of Z
float: ExpectedZSquared; % Expected value of Z squared

% Variables
var float: E_Z_4; % Fourth moment of Z

% Constraints

% Constraint 1: Ensure the expected value of Z is correct
constraint sum(k in 1..K)(k * P[k]) = ExpectedZ;

% Constraint 2: Ensure the expected value of Z squared is correct
constraint sum(k in 1..K)(k^2 * P[k]) = ExpectedZSquared;

% Constraint 3: Define the fourth moment of Z
constraint E_Z_4 = sum(k in 1..K)(k^4 * P[k]);

% Constraint 4: Ensure the fourth moment of Z is within the possible range
constraint E_Z_4 >= 0;
constraint E_Z_4 <= K^4;

% Objective
solve maximize E_Z_4;