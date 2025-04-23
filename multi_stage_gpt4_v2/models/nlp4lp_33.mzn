% Parameters
int: K; % Number of data points
array[1..K] of float: ObservedValues; % Observed y values at each data point k
array[1..K] of float: ObservedXValues; % Observed x values at each data point k

% Variables
var float: a; % Coefficient for the constant term in the quadratic equation
var float: b; % Coefficient for the linear term in the quadratic equation
var float: c; % Coefficient for the quadratic term in the quadratic equation
array[1..K] of var float: PredictedValues; % Predicted y values at each data point k based on the quadratic relationship

% Constraints

% Constraint to calculate predicted values based on the quadratic relationship
constraint forall(k in 1..K) (
    PredictedValues[k] = c * (ObservedXValues[k]^2) + b * ObservedXValues[k] + a
);

% Constraint to ensure the sum of absolute deviations of each observed value of y from the predicted value is minimized
constraint forall(k in 1..K) (
    abs(ObservedValues[k] - PredictedValues[k]) >= 0
);

% Objective
solve minimize sum(k in 1..K) (abs(ObservedValues[k] - PredictedValues[k]));