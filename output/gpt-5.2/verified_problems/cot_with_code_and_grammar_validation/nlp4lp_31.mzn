int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

var -1.0e6..1.0e6: a;
var -1.0e6..1.0e6: b;

array[1..K] of var -1.0e12..1.0e12: yhat;
array[1..K] of var 0.0..1.0e12: dev;

constraint forall(i in 1..K) (
  yhat[i] = b * X[i] + a
);

constraint forall(i in 1..K) (
  dev[i] = abs(Y[i] - yhat[i])
);

solve minimize sum(i in 1..K)(dev[i]);