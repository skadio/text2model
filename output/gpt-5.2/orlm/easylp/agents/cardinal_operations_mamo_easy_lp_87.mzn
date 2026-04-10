% Parameters
int: x_min = 0;          % Minimum hours for task X
int: x_max = 10;         % Maximum hours for task X
int: y_min = 0;          % Minimum hours for task Y
int: y_max = 8;          % Maximum hours for task Y

int: cost_x = 5;         % Cost per hour for task X (dollars)
int: cost_y = 6;         % Cost per hour for task Y (dollars)

int: a1 = 2;             % Coefficient of X in coverage constraint
int: b1 = 3;             % Coefficient of Y in coverage constraint
int: rhs1 = 8;           % Minimum required coverage

int: a2 = 4;             % Coefficient of X in capacity constraint
int: b2 = 1;             % Coefficient of Y in capacity constraint
int: rhs2 = 16;          % Maximum allowed capacity

% Variables
var x_min..x_max: x;     % Integer hours allocated to task X
var y_min..y_max: y;     % Integer hours allocated to task Y

var 0..(cost_x * x_max + cost_y * y_max): total_cost;  % Total cost in dollars

% Constraints
% Link total_cost to the chosen hours for tasks X and Y
constraint
  total_cost = cost_x * x + cost_y * y;

% Coverage / productivity requirement: a1*X + b1*Y must be at least rhs1
constraint
  a1 * x + b1 * y >= rhs1;

% Capacity / limit requirement: a2*X + b2*Y must be at most rhs2
constraint
  a2 * x + b2 * y <= rhs2;

% Objective
solve minimize total_cost;