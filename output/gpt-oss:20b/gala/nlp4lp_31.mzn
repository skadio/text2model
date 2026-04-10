% ------------------------------------------------------------------
%  Linear regression: minimise sum of absolute deviations
% ------------------------------------------------------------------
include "globals.mzn";

int: K;                                   % number of data points (from .dzn)

array[1..K] of float: X;                 % independent variable values
array[1..K] of float: Y;                 % observed dependent values

var float: a;                            % intercept
var float: b;                            % slope

% Objective: minimise the sum of absolute deviations
solve minimize sum([ abs(Y[i] - (b*X[i] + a)) | i in 1..K ]);

output [
  "Intercept (a) = ", show(a), "\n",
  "Slope     (b) = ", show(b), "\n",
  "Sum of abs deviations = ", show(sum([ abs(Y[i] - (b*X[i] + a)) | i in 1..K ])), "\n"
];