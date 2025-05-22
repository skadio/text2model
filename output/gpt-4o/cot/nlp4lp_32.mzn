% Parameters
int: NumObs;
array[1..NumObs] of float: X;
array[1..NumObs] of float: Y;

set of int: OBS = 1..NumObs;

% Variables
var -1.0e6..1.0e6: a;          % Intercept
var -1.0e6..1.0e6: b;          % Slope
var 0.0..1.0e6: maxDev;        % Maximum absolute deviation

% Constraints
constraint
  forall(i in OBS) (
    abs(Y[i] - (b * X[i] + a)) <= maxDev
  );

% Objective
solve minimize maxDev;