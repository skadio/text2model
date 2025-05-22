% Parameters
int: NumObs;
array [1..NumObs] of float: Y;
array [1..NumObs] of float: X;

set of int: Obs = 1..NumObs;

% Variables
var -1.0e9..1.0e9: a;          % Intercept
var -1.0e9..1.0e9: b;          % Slope
var 0.0..1.0e9: t;             % Maximum absolute deviation

% Constraints
constraint
  forall(i in Obs) (
    Y[i] - (a + b * X[i]) <= t
  );

constraint
  forall(i in Obs) (
    -(Y[i] - (a + b * X[i])) <= t
  );

% Objective
solve minimize t;