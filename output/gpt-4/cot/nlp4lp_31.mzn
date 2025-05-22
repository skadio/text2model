% Parameters
int: K;
array[1..K] of float: Y;
array[1..K] of float: X;

% Variables
var float: a;
var float: b;
array[1..K] of var float: Y_pred;
array[1..K] of var float: abs_dev;

% Constraints
constraint forall(i in 1..K) (
    Y_pred[i] = b*X[i] + a
);

constraint forall(i in 1..K) (
    abs_dev[i] = abs(Y[i] - Y_pred[i])
);

% Objective
solve minimize sum(i in 1..K) (abs_dev[i]);