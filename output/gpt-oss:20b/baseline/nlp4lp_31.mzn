int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

var float: a;
var float: b;

solve minimize sum(i in 1..K) abs(Y[i] - (a + b * X[i]));

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "sum_abs_dev = ", show(sum(i in 1..K) abs(Y[i] - (a + b * X[i]))), "\n"
];