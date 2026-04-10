% Parameters
int: NumObs;                         % Number of observed data points (K)
set of int: OBS = 1..NumObs;         % Index set for observations

array[OBS] of float: X;              % Observed values of x
array[OBS] of float: Y;              % Observed values of y


% Variables
var float: a;                        % Intercept of fitted line
var float: b;                        % Slope of fitted line

array[OBS] of var float: y_hat;      % Predicted y values: y_hat[k] = b*X[k] + a
array[OBS] of var float: dev;        % Absolute deviation |Y[k] - y_hat[k]|
var float: max_dev;                  % Maximum deviation over all observations


% Constraints
% Predicted values from the linear model: y_hat[k] = b * X[k] + a
constraint
  forall(k in OBS) (
    y_hat[k] = b * X[k] + a
  );

% Absolute deviation linearization: dev[k] >= |Y[k] - y_hat[k]|
constraint
  forall(k in OBS) (
    dev[k] >= Y[k] - y_hat[k] /\
    dev[k] >= y_hat[k] - Y[k]
  );

% Define max_dev as the maximum of all deviations
constraint
  max_dev = max(k in OBS)(dev[k]);

% Redundant but strengthening: max_dev upper-bounds every deviation
constraint
  forall(k in OBS) (
    max_dev >= dev[k]
  );


% Objective
solve minimize max_dev;