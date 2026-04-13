int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

var -1.0e6..1.0e6: a;
var -1.0e6..1.0e6: b;
array[1..K] of var float: yhat;
array[1..K] of var 0.0..1.0e6: dev;

constraint forall(i in 1..K) (
  yhat[i] = b * X[i] + a
);

constraint forall(i in 1..K) (
  dev[i] >= Y[i] - yhat[i] /\
  dev[i] >= -(Y[i] - yhat[i])
);

solve minimize sum(i in 1..K)(dev[i]);