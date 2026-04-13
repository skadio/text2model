% Parameters
int: NumObs;
set of int: OBS = 1..NumObs;

array[OBS] of float: X;
array[OBS] of float: Y;

% Variables
var float: a;
var float: b;
var float: maxDev;

array[OBS] of var float: yhat;
array[OBS] of var float: dev;

% Constraints
constraint maxDev >= 0.0;

constraint forall(i in OBS)(
  yhat[i] = b * X[i] + a
);

constraint forall(i in OBS)(
  dev[i] = abs(Y[i] - yhat[i])
);

constraint forall(i in OBS)(
  dev[i] <= maxDev
);

% Objective
solve minimize maxDev;