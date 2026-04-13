% Parameters
int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

% Variables
var float: a;
var float: b;
array[1..K] of var float: yhat;
array[1..K] of var float: dev;

% Constraints
constraint forall(i in 1..K) (
  yhat[i] = b * X[i] + a
);

constraint forall(i in 1..K) (
  dev[i] = abs(Y[i] - yhat[i])
);

% Objective
solve minimize sum(i in 1..K)(dev[i]);