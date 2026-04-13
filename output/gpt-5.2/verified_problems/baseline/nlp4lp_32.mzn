int: NumObs;
set of int: OBS = 1..NumObs;

array[OBS] of float: X;
array[OBS] of float: Y;

var float: a;
var float: b;

array[OBS] of var float: yhat;
array[OBS] of var float: dev;

var float: maxDev;

constraint
  forall(i in OBS) (
    yhat[i] = b * X[i] + a /\
    dev[i] >= Y[i] - yhat[i] /\
    dev[i] >= yhat[i] - Y[i] /\
    dev[i] >= 0.0 /\
    maxDev >= dev[i]
  );

constraint maxDev >= 0.0;

solve minimize maxDev;

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "maxDev = ", show(maxDev), "\n"
];