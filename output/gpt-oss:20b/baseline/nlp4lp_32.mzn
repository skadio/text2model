int: NumObs;
array[1..NumObs] of float: X;
array[1..NumObs] of float: Y;

var float: a;
var float: b;
var float: max_e;
array[1..NumObs] of var float: e;

constraint
  forall(i in 1..NumObs) (
    Y[i] - (b * X[i] + a) <= e[i] /\
    -(Y[i] - (b * X[i] + a)) <= e[i] /\
    e[i] <= max_e
  );

solve minimize max_e;

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "max deviation = ", show(max_e), "\n"
];