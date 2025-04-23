% Parameters
int: NumObs; % Number of observed data points
array[1..NumObs] of float: Y; % Observed values of y
array[1..NumObs] of float: X; % Observed values of x

% Variables
var float: a; % Intercept of the best fit line
var float: b; % Slope of the best fit line
array[1..NumObs] of var float: Y_pred; % Predicted values of y
var float: max_deviation; % Maximum deviation of all the observed values of y from the predicted values

% Constraints

% The predicted values of y are calculated using the linear relationship y = bx + a
constraint forall(i in 1..NumObs) (
    Y_pred[i] = b * X[i] + a
);

% The deviation of each observed value of y from the predicted value is less than or equal to the maximum deviation
constraint forall(i in 1..NumObs) (
    abs(Y[i] - Y_pred[i]) <= max_deviation
);

% The maximum deviation is non-negative
constraint max_deviation >= 0;

% Objective
solve minimize max_deviation;