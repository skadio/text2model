% Parameters
int: K;                                   % Number of data points
set of int: DATA_POINTS = 1..K;           % Index set for data points

array[DATA_POINTS] of float: ObservedValues;    % Observed y values
array[DATA_POINTS] of float: ObservedXValues;   % Observed x values


% Variables
var float: a;                             % Quadratic intercept term
var float: b;                             % Quadratic linear coefficient
var float: c;                             % Quadratic squared coefficient

array[DATA_POINTS] of var float: y_pred;  % Predicted y for each data point
array[DATA_POINTS] of var float: abs_dev; % Absolute deviation |ObservedValues[k] - y_pred[k]|

var float: total_abs_deviation;           % Objective: sum of absolute deviations


% Constraints

% --- Predicted values: enforce quadratic model y_pred[k] = c*x^2 + b*x + a
constraint
  forall(k in DATA_POINTS) (
    y_pred[k] = c * (ObservedXValues[k] * ObservedXValues[k]) + b * ObservedXValues[k] + a
  );

% --- Absolute deviations: abs_dev[k] = |ObservedValues[k] - y_pred[k]|
constraint
  forall(k in DATA_POINTS) (
    abs_dev[k] = abs(ObservedValues[k] - y_pred[k])
  );

% --- Total absolute deviation: sum over all data points
constraint
  total_abs_deviation = sum(k in DATA_POINTS)(abs_dev[k]);


% Objective
solve minimize total_abs_deviation;