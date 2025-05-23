% Parameters
int: K; % Number of data points
array[1..K] of float: Y; % Observed values of the dependent variable
array[1..K] of float: X; % Observed values of the independent variable

% Variables
var float: a; % Intercept of the best fit line
var float: b; % Slope of the best fit line
array[1..K] of var float: Y_pred; % Predicted values of the dependent variable

% Constraints

% The predicted values of Y are calculated using the linear relationship y = bx + a
constraint forall(i in 1..K) (
    Y_pred[i] = b * X[i] + a
);

% The absolute deviations of each observed value of Y from the predicted value should be minimized
constraint forall(i in 1..K) (
    abs(Y[i] - Y_pred[i]) <= abs(Y[i] - (b * X[i] + a))
);

% Objective
solve minimize sum(i in 1..K)(abs(Y[i] - Y_pred[i]));