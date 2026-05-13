% Parameters
int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

% Variables
var float: a;
var float: b;
var float: c;
array[1..K] of var float: residuals;

% Constraints
constraint
  forall(k in 1..K) (
    residuals[k] = abs(c*ObservedXValues[k]^2 + b*ObservedXValues[k] + a - ObservedValues[k])
  );

% Objective
solve minimize sum(residuals);