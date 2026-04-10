int: K;                   % Number of data points
array[1..K] of float: X;  % Independent variable values
array[1..K] of float: Y;  % Observed dependent variable values

% Decision variables: parameters of the line y = b*x + a
var float: a;
var float: b;

% Variables representing the absolute deviation for each data point
array[1..K] of var float: deviation;

% Link each deviation with the absolute error from the line's prediction
constraint forall(i in 1..K) (
    deviation[i] = abs(Y[i] - (b * X[i] + a))
);

% Objective: minimize the sum of the absolute deviations
var float: totalDeviation = sum(i in 1..K)(deviation[i]);

solve minimize totalDeviation;

output [
  "Best fit line: y = ", show(b), " * x + ", show(a), "\n",
  "Total absolute deviation = ", show(totalDeviation)
];