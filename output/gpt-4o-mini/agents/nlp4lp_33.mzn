int: K;  % Number of data points
array[1..K] of float: ObservedValues;  % Observed y values
array[1..K] of float: ObservedXValues;  % Observed x values

% Variables for the coefficients of the quadratic equation
var float: a;  % constant term
var float: b;  % linear term
var float: c;  % quadratic term

% Variables to hold the predicted y values
array[1..K] of var float: PredictedValues;

% Define the predicted values based on the quadratic equation
constraint forall(k in 1..K) (
    PredictedValues[k] = c * ObservedXValues[k]^2 + b * ObservedXValues[k] + a
);

% Objective: Minimize the sum of absolute deviations
var float: total_deviation;
constraint total_deviation = sum(k in 1..K)(abs(ObservedValues[k] - PredictedValues[k]));

% Solve the model
solve minimize total_deviation;

% Output the results
output [
    "Coefficients: a = ", show(a), ", b = ", show(b), ", c = ", show(c), "\n",
    "Total Deviation = ", show(total_deviation), "\n"
];