int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

var float: a;
var float: b;
var float: c;

array[1..K] of var float: yhat;
array[1..K] of var float: dev_abs;

constraint forall(k in 1..K) (
  yhat[k] = c * ObservedXValues[k] * ObservedXValues[k]
          + b * ObservedXValues[k]
          + a
);

constraint forall(k in 1..K) (
  dev_abs[k] = abs(ObservedValues[k] - yhat[k])
);

solve minimize sum(k in 1..K)(dev_abs[k]);

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "c = ", show(c), "\n",
  "objective = ", show(sum(k in 1..K)(dev_abs[k])), "\n"
];