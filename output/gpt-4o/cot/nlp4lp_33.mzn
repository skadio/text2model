% Parameters
int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

% Variables
var float: a;                % intercept
var float: b;                % linear coefficient
var float: c;                % quadratic coefficient

array[1..K] of var float: y_hat;
array[1..K] of var float >= 0.0: abs_dev;

% Constraints
constraint
  forall(k in 1..K) (
    y_hat[k] = a + b * ObservedXValues[k] + c * ObservedXValues[k] * ObservedXValues[k]
  );

constraint
  forall(k in 1..K) (
        abs_dev[k] >=  ObservedValues[k] - y_hat[k] /\
        abs_dev[k] >=  y_hat[k] - ObservedValues[k]
  );

% Objective
solve minimize sum(k in 1..K)(abs_dev[k]);