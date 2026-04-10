% Parameters
int: K;
set of int: POINTS = 1..K;

array[POINTS] of float: ObservedValues;
array[POINTS] of float: ObservedXValues;

% Variables (bounded to avoid backend "Number out of limits" errors)
var -1.0e6..1.0e6: a;
var -1.0e6..1.0e6: b;
var -1.0e6..1.0e6: c;

array[POINTS] of var -1.0e12..1.0e12: y_pred;
array[POINTS] of var 0.0..1.0e12: abs_dev;

% Constraints
constraint
  forall(k in POINTS) (
    y_pred[k] = c * (ObservedXValues[k] * ObservedXValues[k])
              + b * ObservedXValues[k]
              + a
  );

constraint
  forall(k in POINTS) (
    abs_dev[k] = abs(ObservedValues[k] - y_pred[k])
  );

% Objective
solve minimize sum(k in POINTS)(abs_dev[k]);