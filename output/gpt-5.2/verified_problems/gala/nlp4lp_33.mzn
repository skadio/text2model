% Quadratic regression with L1 loss (sum of absolute deviations)
% Fit: y ≈ c*x^2 + b*x + a

int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

% Coefficients to fit (unbounded by default; bounds can be added in .dzn if desired)
var float: a;
var float: b;
var float: c;

% Predicted values and absolute deviations
array[1..K] of var float: yhat;
array[1..K] of var float: dev;

constraint
  forall(k in 1..K) (
    yhat[k] = c * ObservedXValues[k] * ObservedXValues[k] + b * ObservedXValues[k] + a
  );

constraint
  forall(k in 1..K) (
    dev[k] >= ObservedValues[k] - yhat[k] /\
    dev[k] >= yhat[k] - ObservedValues[k]
  );

var float: obj = sum(k in 1..K)(dev[k]);

solve minimize obj;

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "c = ", show(c), "\n",
  "objective (sum abs dev) = ", show(obj), "\n",
  "predicted = ", show(yhat), "\n",
  "abs_dev   = ", show(dev), "\n"
];