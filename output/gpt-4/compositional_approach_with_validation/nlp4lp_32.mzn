% Parameters
int: NumObs; % Number of observed data points
array[1..NumObs] of float: Y; % Observed values of y
array[1..NumObs] of float: X; % Observed values of x

% Variables
var float: a; % Intercept of the best fit line
var float: b; % Slope of the best fit line
var float: max_deviation; % Maximum deviation of observed y values from predicted y values

% Constraints

% The predicted y values should be equal to bx + a for all observed x values
constraint forall(i in 1..NumObs) (
    abs(Y[i] - (b*X[i] + a)) <= max_deviation
);

% Objective
solve minimize max_deviation;