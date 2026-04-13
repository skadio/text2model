% Parameters
int: capacity_total = 500;          % Maximum combined cargo capacity
int: min_x = 200;                   % Minimum feasible allocation for freight type X
int: min_y = 100;                   % Minimum feasible allocation for freight type Y
float: cost_x = 0.05;               % Cost per unit of freight type X
float: cost_y = 0.1;                % Cost per unit of freight type Y

% Variables
var min_x..capacity_total: x_units; % Whole-number units allocated to freight type X
var min_y..capacity_total: y_units; % Whole-number units allocated to freight type Y
var float: total_cost;              % Total cost to minimize

% Constraints
% Capacity constraint: total allocated units cannot exceed vehicle capacity
constraint
  x_units + y_units <= capacity_total;

% Cost definition constraint: total_cost computed from per-unit costs
constraint
  total_cost = cost_x * int2float(x_units) + cost_y * int2float(y_units);

% Objective
solve minimize total_cost;

output [
  "x_units=", show(x_units), "\n",
  "y_units=", show(y_units), "\n",
  "total_cost=", show_float(1, total_cost), "\n"
];