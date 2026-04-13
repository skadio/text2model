% Parameters
int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

% Variables
var float: a;
var float: b;
array[1..K] of var float: yhat;
array[1..K] of var float: dev;
var float: obj;

% Constraints
constraint forall(i in 1..K) (
  yhat[i] = b * X[i] + a
);

constraint forall(i in 1..K) (
  dev[i] >= Y[i] - yhat[i] /\
  dev[i] >= -(Y[i] - yhat[i])
);

constraint forall(i in 1..K) (dev[i] >= 0.0);

constraint obj = sum(i in 1..K)(dev[i]);

% Objective
solve minimize obj;