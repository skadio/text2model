% Parameters
int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

% Variables
var float: a;
var float: b;
array[1..K] of var float: d;

% Constraints
constraint forall(i in 1..K) (
    d[i] >= abs(Y[i] - (b * X[i] + a))
);

% Objective
solve minimize sum(d);