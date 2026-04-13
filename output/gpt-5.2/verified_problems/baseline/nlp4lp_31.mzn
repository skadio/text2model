int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

var float: a;
var float: b;

array[1..K] of var float: dev;
var float: obj;

constraint forall(i in 1..K)(
  dev[i] >=  Y[i] - (b * X[i] + a) /\
  dev[i] >= -(Y[i] - (b * X[i] + a))
);

constraint obj = sum(i in 1..K)(dev[i]);

solve minimize obj;

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "sum_abs_dev = ", show(obj), "\n"
];