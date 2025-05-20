% Input Data Nomenclature
int: K; % Number of data points
array[1..K] of float: Y; % Observed values of the dependent variable
array[1..K] of float: X; % Observed values of the independent variable

% Variables
var float: a; % Intercept of the line
var float: b; % Slope of the line
array[1..K] of var float: E; % Absolute deviations

% Constraints
constraint forall(i in 1..K) (
    E[i] >= Y[i] - (b*X[i] + a) /\ E[i] >= (b*X[i] + a) - Y[i]
);

% Objective
var float: obj = sum(i in 1..K)(E[i]);
solve minimize obj;

% Output
output ["a = ", show(a), "\nb = ", show(b), "\nobj = ", show(obj)];