int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

% Decision variables: quadratic coefficients
var float: a;
var float: b;
var float: c;

% Predicted values and absolute deviations
array[1..K] of var float: Predicted =
  [ c * ObservedXValues[k] * ObservedXValues[k] + b * ObservedXValues[k] + a | k in 1..K ];

array[1..K] of var float: AbsDev;

constraint
  forall(k in 1..K) (
    AbsDev[k] >= ObservedValues[k] - Predicted[k] /\
    AbsDev[k] >= Predicted[k] - ObservedValues[k]
  );

solve minimize sum(k in 1..K)(AbsDev[k]);

output [
  "a=", show(a), "\n",
  "b=", show(b), "\n",
  "c=", show(c), "\n",
  "objective=", show(sum(k in 1..K)(AbsDev[k])), "\n"
];