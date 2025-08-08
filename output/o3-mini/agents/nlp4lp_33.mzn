% Quadratic curve fitting: y = c*x^2 + b*x + a
% Objective: minimize the sum of absolute deviations between observed and predicted y values

int: K;                                    % Number of data points
array[1..K] of float: ObservedXValues;     % Observed x values
array[1..K] of float: ObservedValues;        % Observed y values

% Decision variables: The parameters of the quadratic curve.
% Bounds are set arbitrarily; adjust if needed.
var -1e6..1e6: a;
var -1e6..1e6: b;
var -1e6..1e6: c;

% Define the total absolute error
var float: totalError = sum(k in 1..K)(
    abs(ObservedValues[k] - (c * ObservedXValues[k]*ObservedXValues[k] + b * ObservedXValues[k] + a))
);

solve minimize totalError;

output [
  "Best fit quadratic curve: y = ", show(c), " * x^2 + ", show(b), " * x + ", show(a), "\n",
  "Total absolute deviation: ", show(totalError), "\n"
];