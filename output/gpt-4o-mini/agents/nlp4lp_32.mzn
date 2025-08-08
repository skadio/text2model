int: NumObs;                          % Number of observed data points
array[1..NumObs] of float: Y;        % Observed values of y
array[1..NumObs] of float: X;        % Observed values of x

% Variables for the linear regression coefficients
var float: a;                        % Intercept
var float: b;                        % Slope

% Variables for the deviations
array[1..NumObs] of var float: deviations; % Deviations from the predicted values

% Constraints to define the deviations
constraint forall(i in 1..NumObs) (
    deviations[i] = Y[i] - (b * X[i] + a)
);

% Objective: minimize the maximum deviation
var float: max_deviation;
constraint max_deviation = max(i in 1..NumObs)(abs(deviations[i]));
solve minimize max_deviation;

% Output the results
output [
    "Intercept (a) = ", show(a), "\n",
    "Slope (b) = ", show(b), "\n",
    "Maximum Deviation = ", show(max_deviation), "\n"
];