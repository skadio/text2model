% Parameters
int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

% Variables
float: COEFF_BOUND = 1.0e3;

var -COEFF_BOUND..COEFF_BOUND: a;
var -COEFF_BOUND..COEFF_BOUND: b;
var -COEFF_BOUND..COEFF_BOUND: c;

array[1..K] of var 0.0..COEFF_BOUND: dev;

% Constraints
constraint
  forall(k in 1..K)(
    dev[k] >= 0.0
  );

constraint
  forall(k in 1..K)(
    dev[k] >= (a + b * ObservedXValues[k] + c * ObservedXValues[k] * ObservedXValues[k])
             - ObservedValues[k]
  );

constraint
  forall(k in 1..K)(
    dev[k] >= ObservedValues[k]
             - (a + b * ObservedXValues[k] + c * ObservedXValues[k] * ObservedXValues[k])
  );

% Objective
solve minimize sum(k in 1..K)(dev[k]);