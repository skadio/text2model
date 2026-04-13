int: NumObs;
set of int: OBS = 1..NumObs;

array[OBS] of float: X;
array[OBS] of float: Y;

var -1.0e6..1.0e6: a;
var -1.0e6..1.0e6: b;
var 0.0..1.0e6: D;

array[OBS] of var float: yhat;

constraint forall(i in OBS) (
  yhat[i] = b * X[i] + a
);

constraint forall(i in OBS) (
  D >= Y[i] - yhat[i]
);

constraint forall(i in OBS) (
  D >= yhat[i] - Y[i]
);

solve minimize D;

output ["a=", show(a), " b=", show(b), " D=", show(D)];