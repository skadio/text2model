% Parameters
int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

% Variables
var float: a;
var float: b;
var float: c;

% Constraints
constraint forall(k in 1..K) (
    let { var float: PredictedValue = c * (ObservedXValues[k]*ObservedXValues[k]) + b * ObservedXValues[k] + a } in
    abs(ObservedValues[k] - PredictedValue) <= 0.01
);

% Objective
solve minimize sum(k in 1..K) (abs(ObservedValues[k] - (c * (ObservedXValues[k]*ObservedXValues[k]) + b * ObservedXValues[k] + a)));