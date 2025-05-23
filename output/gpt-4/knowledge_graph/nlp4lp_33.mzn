% Parameters
int: K; % Number of data points
array[1..K] of float: ObservedValues; % Observed y values at each data point k
array[1..K] of float: ObservedXValues; % Observed x values at each data point k

% Variables
var float: a; % constant term
var float: b; % coefficient of x
var float: c; % coefficient of x^2
array[1..K] of var float: PredictedValues; % Predicted y values at each data point k

% Constraints
constraint forall(k in 1..K) (
    PredictedValues[k] = c * (ObservedXValues[k]^2) + b * ObservedXValues[k] + a
);

% Objective
var float: TotalDeviation = sum(k in 1..K) (abs(ObservedValues[k] - PredictedValues[k]));
solve minimize TotalDeviation;

% Output
output ["a = ", show(a), "\nb = ", show(b), "\nc = ", show(c)];