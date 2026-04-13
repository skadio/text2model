int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

var float: a;
var float: b;

array[1..K] of var float: dev;

constraint
  forall(i in 1..K)(
    dev[i] = abs(Y[i] - (b * X[i] + a))
  );

solve minimize sum(i in 1..K)(dev[i]);

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "objective = ", show(sum(i in 1..K)(dev[i])), "\n"
];