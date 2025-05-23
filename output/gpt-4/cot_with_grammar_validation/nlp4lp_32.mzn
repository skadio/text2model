% Parameters
int: NumObs;
array[1..NumObs] of float: Y;
array[1..NumObs] of float: X;

% Variables
var float: a; % intercept of the line
var float: b; % slope of the line
var float: max_deviation; % maximum deviation

% Constraints
constraint forall(i in 1..NumObs) (
  abs(float(Y[i]) - (b*float(X[i]) + a)) <= max_deviation
);

% Objective
solve minimize max_deviation;