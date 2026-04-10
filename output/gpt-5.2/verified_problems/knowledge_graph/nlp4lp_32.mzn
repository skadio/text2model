int: NumObs;
array[1..NumObs] of float: X;
array[1..NumObs] of float: Y;

var float: a;
var float: b;

var float: maxDev;
array[1..NumObs] of var float: dev;

constraint
  forall(i in 1..NumObs) (
    dev[i] = abs(Y[i] - (b * X[i] + a))
  );

constraint
  forall(i in 1..NumObs) (
    dev[i] <= maxDev
  );

solve minimize maxDev;

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "maxDev = ", show(maxDev), "\n"
];