% Parameters
int: K;                              % Number of data points
set of int: POINTS = 1..K;           % Index set for data points

array[POINTS] of float: X;           % Observed values of independent variable
array[POINTS] of float: Y;           % Observed values of dependent variable


% Variables
var float: a;                        % Intercept of fitted line
var float: b;                        % Slope of fitted line

array[POINTS] of var float: y_hat;   % Predicted y-values: y_hat[k] = b*X[k] + a
array[POINTS] of var float: dev;     % Absolute deviations: dev[k] = |Y[k] - y_hat[k]|


% Constraints

% Predicted values: enforce linear model y_hat[k] = b * X[k] + a
constraint
  forall(k in POINTS) (
    y_hat[k] = b * X[k] + a
  );

% Absolute deviation definition: dev[k] = |Y[k] - y_hat[k]|
constraint
  forall(k in POINTS) (
    dev[k] = abs(Y[k] - y_hat[k])
  );


% Objective
solve minimize sum(k in POINTS)(dev[k]);