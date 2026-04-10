% Quadratic regression with L1 (absolute deviation) objective
% y = c*x^2 + b*x + a

% Parameters
int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

% Decision variables (bounded to help solvers)
var -1.0e6..1.0e6: a;
var -1.0e6..1.0e6: b;
var -1.0e6..1.0e6: c;

array[1..K] of var float: Predicted;
array[1..K] of var float: AbsDev;
var float: TotalAbsDev;

% Constraints
constraint forall(k in 1..K) (
  Predicted[k] = c * ObservedXValues[k] * ObservedXValues[k]
               + b * ObservedXValues[k]
               + a
);

constraint forall(k in 1..K) (
  AbsDev[k] = abs(ObservedValues[k] - Predicted[k])
);

constraint TotalAbsDev = sum(k in 1..K)(AbsDev[k]);

% Objective
solve minimize TotalAbsDev;

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "c = ", show(c), "\n",
  "TotalAbsDev = ", show(TotalAbsDev), "\n"
];