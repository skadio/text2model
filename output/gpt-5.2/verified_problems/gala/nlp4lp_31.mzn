% Least Absolute Deviations (L1) linear regression: y = b*x + a
% Minimise sum_i |Y[i] - (b*X[i] + a)|
%
% Data (.dzn) must provide:
%   int: K;
%   array[1..K] of float: X;
%   array[1..K] of float: Y;

int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

% Decision variables (unbounded reals in MiniZinc; solvers may bound internally)
var float: a;
var float: b;

array[1..K] of var float: yhat;
array[1..K] of var float: dev;
array[1..K] of var float: absdev;

constraint forall(i in 1..K) (
  yhat[i] = b * X[i] + a /\
  dev[i]  = Y[i] - yhat[i] /\
  absdev[i] >= dev[i] /\
  absdev[i] >= -dev[i] /\
  absdev[i] >= 0.0
);

var float: obj = sum(i in 1..K)(absdev[i]);

solve minimize obj;

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "sum_abs_dev = ", show(obj), "\n",
  "yhat = ", show(yhat), "\n",
  "absdev = ", show(absdev), "\n"
];