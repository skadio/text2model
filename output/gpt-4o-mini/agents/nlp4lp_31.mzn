int: K;                             % Number of data points
array[1..K] of float: Y;           % Observed values of the dependent variable
array[1..K] of float: X;           % Observed values of the independent variable

% Variables for the linear regression coefficients
var float: a;                       % Intercept
var float: b;                       % Slope

% Variables for the absolute deviations
array[1..K] of var float: deviations;

% Constraints to define the deviations
constraint forall(i in 1..K) (
    deviations[i] = abs(Y[i] - (b * X[i] + a))
);

% Objective: Minimize the sum of absolute deviations
var float: total_deviation = sum(deviations);
solve minimize total_deviation;

% Output the results
output [
    "Intercept (a) = ", show(a), "\n",
    "Slope (b) = ", show(b), "\n",
    "Total Absolute Deviation = ", show(total_deviation), "\n"
];