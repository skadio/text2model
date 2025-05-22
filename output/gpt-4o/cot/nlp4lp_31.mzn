% Parameters
int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

% Variables
var -1.0e6..1.0e6: a;                 % Intercept
var -1.0e6..1.0e6: b;                 % Slope
array[1..K] of var 0.0..1.0e6: dev;   % Absolute deviations

% Constraints
constraint
  forall(i in 1..K)(
       dev[i] >=  Y[i] - (a + b * X[i])
  /\   dev[i] >= (a + b * X[i]) - Y[i]
  );

% Objective
solve minimize sum(i in 1..K)(dev[i]);