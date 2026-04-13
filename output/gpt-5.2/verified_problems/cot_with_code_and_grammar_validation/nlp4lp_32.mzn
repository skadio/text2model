int: NumObs;
set of int: OBS = 1..NumObs;

array[OBS] of float: X;
array[OBS] of float: Y;

var float: a;
var float: b;
var float: t;

constraint t >= 0.0;

constraint forall(k in OBS) (
  Y[k] - (b * X[k] + a) <= t /\
  (b * X[k] + a) - Y[k] <= t
);

solve minimize t;