% Parameters
int: K;
set of int: POINTS = 1..K;

array[POINTS] of float: ObservedValues;
array[POINTS] of float: ObservedXValues;

% Variables
var float: a;
var float: b;
var float: c;

array[POINTS] of var float: yhat;
array[POINTS] of var float: dev;
array[POINTS] of var float: absdev;

var float: total_abs_dev;

% Constraints
constraint
  forall(k in POINTS) (
    yhat[k] = c * ObservedXValues[k] * ObservedXValues[k] + b * ObservedXValues[k] + a
  );

constraint
  forall(k in POINTS) (
    dev[k] = ObservedValues[k] - yhat[k]
  );

constraint
  forall(k in POINTS) (
    absdev[k] >= dev[k] /\
    absdev[k] >= -dev[k] /\
    absdev[k] >= 0.0
  );

constraint
  total_abs_dev = sum(k in POINTS)(absdev[k]);

% Objective
solve minimize total_abs_dev;