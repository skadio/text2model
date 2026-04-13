% Parameters
int: K;                              % Number of data points
set of int: P = 1..K;                % Index set for data points

array[P] of float: X;                % Observed independent variable values
array[P] of float: Y;                % Observed dependent variable values

% ---- Bound helper values to avoid unbounded float variables (Gecode limitation) ----
float: minX = min(X);
float: maxX = max(X);
float: minY = min(Y);
float: maxY = max(Y);

% Conservative search bounds (wide enough for typical data; avoids "Number out of limits")
float: b_lo = -1.0e4;
float: b_hi =  1.0e4;
float: a_lo = minY - 1.0e4 * max(abs(minX), abs(maxX)) - 1.0e4;
float: a_hi = maxY + 1.0e4 * max(abs(minX), abs(maxX)) + 1.0e4;

% Variables
var b_lo..b_hi: b;                   % Slope of fitted line
var a_lo..a_hi: a;                   % Intercept of fitted line

array[P] of var float: y_hat;        % Predicted y values (b*X + a)
array[P] of var float: abs_dev;      % Absolute deviations |Y - y_hat|

var 0.0..1.0e12: total_abs_dev;      % Objective: sum of absolute deviations

% Constraints
constraint
  forall(i in P) (
    y_hat[i] = b * X[i] + a
  );

constraint
  forall(i in P) (
    abs_dev[i] = abs(Y[i] - y_hat[i])
  );

constraint
  total_abs_dev = sum(i in P)(abs_dev[i]);

% Objective
solve minimize total_abs_dev;