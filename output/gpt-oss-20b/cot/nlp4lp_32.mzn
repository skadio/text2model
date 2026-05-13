% Parameters
int: NumObs;
array[1..NumObs] of float: Y;
array[1..NumObs] of float: X;

% Variables
var float: a;
var float: b;
var float: maxDev;

% Constraints
constraint maxDev >= 0;
constraint forall(i in 1..NumObs) (
    abs(Y[i] - (b * X[i] + a)) <= maxDev
);

% Objective
solve minimize maxDev;