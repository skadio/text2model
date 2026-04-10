% Parameters
int: NumObs;
set of int: OBS = 1..NumObs;

array[OBS] of float: X;
array[OBS] of float: Y;

% Variables
var float: a;
var float: b;
var float: z; % maximum absolute deviation (>= 0)

array[OBS] of var float: yhat;

% Constraints
constraint z >= 0.0;

constraint forall(i in OBS) (
  yhat[i] = b * X[i] + a
);

% Enforce |Y[i] - yhat[i]| <= z for all observations
constraint forall(i in OBS) (
  (Y[i] - yhat[i] <= z) /\ (yhat[i] - Y[i] <= z)
);

% Objective
solve minimize z;

output [
  "a = ", show(a), "\n",
  "b = ", show(b), "\n",
  "z = ", show(z), "\n"
];