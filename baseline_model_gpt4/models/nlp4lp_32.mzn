include "globals.mzn";

% Number of observed data points
int: NumObs;

% Observed values of y
array[1..NumObs] of float: Y;

% Observed values of x
array[1..NumObs] of float: X;

% Variables for the coefficients a and b
var float: a;
var float: b;

% Variable for the maximum deviation
var float: max_dev;

% The objective is to minimize the maximum deviation
solve minimize max_dev;

% Constraints
constraint forall(i in 1..NumObs) (
  abs(Y[i] - (b*X[i] + a)) <= max_dev
);