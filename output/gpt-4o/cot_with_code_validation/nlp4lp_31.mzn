% Parameters
int: K;
array[1..K] of float: X;
array[1..K] of float: Y;

% Variables
var -1.0e6 .. 1.0e6: a;                 % Intercept of the line
var -1.0e6 .. 1.0e6: b;                 % Slope of the line
array[1..K] of var 0.0 .. 1.0e6: D;     % Absolute deviations |Y[i] - (b*X[i] + a)|

% Constraints
constraint
  forall(i in 1..K) (
    D[i] >= Y[i] - (b * X[i] + a)
  );

constraint
  forall(i in 1..K) (
    D[i] >= -(Y[i] - (b * X[i] + a))
  );

% Objective
solve minimize sum(i in 1..K)(D[i]);