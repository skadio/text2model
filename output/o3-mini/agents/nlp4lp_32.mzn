% Data is supplied in a .dzn file:
% int: NumObs;
% array[1..NumObs] of float: X;
% array[1..NumObs] of float: Y;

var float: a;        % intercept
var float: b;        % slope
var float: d;        % maximum absolute deviation

constraint
   forall(k in 1..NumObs) (
      abs(Y[k] - (b * X[k] + a)) <= d
   );

solve minimize d;

output [
  "Intercept (a) = ", show(a), "\n",
  "Slope (b)     = ", show(b), "\n",
  "Max Deviation = ", show(d), "\n",
  "Predicted Y   = ", show([ b * X[k] + a | k in 1..NumObs ]), "\n"
];