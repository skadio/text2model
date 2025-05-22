% Parameters
int: NumObs;
array[1..NumObs] of float: Y;
array[1..NumObs] of float: X;

% Variables
var -1000000.0..1000000.0: a;
var -1000000.0..1000000.0: b;
var 0.0..1000000.0: max_deviation;

% Constraints
constraint forall(i in 1..NumObs) (
  abs(Y[i] - (b*X[i] + a)) <= max_deviation
);

% Objective
solve minimize max_deviation;