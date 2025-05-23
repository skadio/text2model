% Parameters
int: NumObs;
array[1..NumObs] of float: Y;
array[1..NumObs] of float: X;

% Variables
var float: a; % intercept of the line
var float: b; % slope of the line
array[1..NumObs] of var float: Y_pred; % predicted values of Y
var float: max_deviation; % maximum deviation

% Constraints
constraint forall(i in 1..NumObs) (
    Y_pred[i] = b*X[i] + a
);
constraint forall(i in 1..NumObs) (
    abs(Y[i] - Y_pred[i]) <= max_deviation
);

% Objective
solve minimize max_deviation;