include "globals.mzn";

% Parameters
int: K;
array[1..K] of float: ObservedValues;
array[1..K] of float: ObservedXValues;

% Variables
var float: a;
var float: b;
var float: c;
array[1..K] of var float: PredictedValues;
array[1..K] of var float: Deviations;

% Constraints
constraint forall(k in 1..K) (
    PredictedValues[k] = c * (ObservedXValues[k]^2) + b * ObservedXValues[k] + a
);

constraint forall(k in 1..K) (
    Deviations[k] = abs(ObservedValues[k] - PredictedValues[k])
);

% Objective
var float: total_deviation = sum(Deviations);
solve minimize total_deviation;

% Output
output ["a = ", show(a), "\nb = ", show(b), "\nc = ", show(c)];