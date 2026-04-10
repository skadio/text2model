% Minimax linear regression: fit y = b*x + a minimizing maximum absolute deviation

int: NumObs;
array[1..NumObs] of float: X;
array[1..NumObs] of float: Y;

% Decision variables (unbounded reals are fine for most solvers; can be bounded in .dzn if desired)
var float: a;
var float: b;

% Maximum absolute deviation
var float: z;

constraint z >= 0.0;

% For each observation i: |Y[i] - (b*X[i] + a)| <= z
constraint
  forall(i in 1..NumObs) (
    Y[i] - (b * X[i] + a) <= z /\
    (b * X[i] + a) - Y[i] <= z
  );

solve minimize z;

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "max_abs_deviation z = ", show(z), "\n",
  "predicted = ", show([ b*X[i] + a | i in 1..NumObs ]), "\n",
  "residuals = ", show([ Y[i] - (b*X[i] + a) | i in 1..NumObs ]), "\n"
];