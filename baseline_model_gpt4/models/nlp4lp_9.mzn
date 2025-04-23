% Input parameters
int: K; % Number of terms in the sequence
array[1..K] of float: P; % Coefficients of the linear combination
float: ExpectedZ; % Expected value of Z
float: ExpectedZSquared; % Expected value of Z squared

% Decision variable
var float: ExpectedZFourth; % Expected value of Z to the fourth power

% Constraints
constraint forall(k in 1..K) (
    ExpectedZFourth >= k^4 * P[k]
);

constraint ExpectedZ = sum(k in 1..K) (k * P[k]);
constraint ExpectedZSquared = sum(k in 1..K) (k^2 * P[k]);

% Objective function
solve maximize ExpectedZFourth;

% Output
output ["ExpectedZFourth: ", show(ExpectedZFourth)];