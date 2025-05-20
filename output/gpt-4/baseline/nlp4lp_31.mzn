% Input parameters
int: K; % Number of data points
array[1..K] of float: Y; % Observed values of the dependent variable
array[1..K] of float: X; % Observed values of the independent variable

% Decision variables
var float: a; % Intercept of the line
var float: b; % Slope of the line

% Auxiliary variables
array[1..K] of var float: Y_pred; % Predicted values of Y

% Constraints
constraint forall(i in 1..K) (
    Y_pred[i] = b*X[i] + a
);

% Objective function
var float: obj = sum(i in 1..K)(abs(Y[i] - Y_pred[i]));
minimize obj;

% Output
output ["a = ", show(a), "\nb = ", show(b), "\nobj = ", show(obj)];