% Parameters
int: NumObs;                                 % Number of observed data points (K)
set of int: OBS = 1..NumObs;                 % Index set for observations

array[OBS] of float: Y;                      % Observed y-values
array[OBS] of float: X;                      % Observed x-values

% Use finite bounds to avoid backend "Number out of limits" issues.
float: Xmin = min([X[k] | k in OBS]);
float: Xmax = max([X[k] | k in OBS]);
float: Ymin = min([Y[k] | k in OBS]);
float: Ymax = max([Y[k] | k in OBS]);
float: Xspan = max(1.0e-6, Xmax - Xmin);
float: Yspan = max(1.0e-6, Ymax - Ymin);

% Variables (bounded)
var float: a = (Ymin - 10.0*Yspan) .. (Ymax + 10.0*Yspan);            % Intercept
var float: b = (-10.0*Yspan / Xspan) .. (10.0*Yspan / Xspan);         % Slope

array[OBS] of var float: y_pred;                                      % Predicted y
array[OBS] of var float: dev = array1d(OBS, [0.0..(100.0*Yspan) | k in OBS]);
var float: max_dev = 0.0 .. (100.0*Yspan);

% Constraints
constraint
  forall(k in OBS) (
    y_pred[k] = b * X[k] + a
  );

constraint
  forall(k in OBS) (
    dev[k] = abs(Y[k] - y_pred[k])
  );

constraint
  forall(k in OBS) (
    dev[k] <= max_dev
  );

% Objective
solve minimize max_dev;