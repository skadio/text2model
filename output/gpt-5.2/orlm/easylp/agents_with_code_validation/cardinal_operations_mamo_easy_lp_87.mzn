% Parameters
int: x_min = 0;              % Minimum hours for task X
int: x_max = 10;             % Maximum hours for task X
int: y_min = 0;              % Minimum hours for task Y
int: y_max = 8;              % Maximum hours for task Y

int: cost_x = 5;             % Cost per hour for task X
int: cost_y = 6;             % Cost per hour for task Y

int: a1 = 2;                 % Coefficient for X in constraint 1
int: b1 = 3;                 % Coefficient for Y in constraint 1
int: rhs1 = 8;               % Right-hand side for constraint 1 (>=)

int: a2 = 4;                 % Coefficient for X in constraint 2
int: b2 = 1;                 % Coefficient for Y in constraint 2
int: rhs2 = 16;              % Right-hand side for constraint 2 (<=)

% Variables
var x_min..x_max: x;         % Integer hours allocated to task X
var y_min..y_max: y;         % Integer hours allocated to task Y

var 0..(cost_x*x_max + cost_y*y_max): total_cost;  % Total cost to minimize

% Constraints
% Compute total cost from chosen hours (keeps total_cost consistent)
constraint total_cost = cost_x * x + cost_y * y;

% Productivity / coverage requirement: 2*X + 3*Y >= 8
constraint a1 * x + b1 * y >= rhs1;

% Capacity / upper bound requirement: 4*X + 1*Y <= 16
constraint a2 * x + b2 * y <= rhs2;

% Objective
solve minimize total_cost;