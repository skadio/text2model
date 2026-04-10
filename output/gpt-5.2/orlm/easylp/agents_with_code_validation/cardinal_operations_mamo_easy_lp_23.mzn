% Parameters
int: capacity = 200;                 % Maximum total units producible (X + Y)
int: demand_min = 400;               % Minimum required combined output: 3X + 2Y >= demand_min

int: coeff_x = 3;                    % Contribution of one unit of X to demand expression
int: coeff_y = 2;                    % Contribution of one unit of Y to demand expression

int: cost_x = 500;                   % Cost per unit of X (in dollars)
int: cost_y = 300;                   % Cost per unit of Y (in dollars)

% Variables
var 0..capacity: x_units;            % Units of product X (integer, non-negative)
var 0..capacity: y_units;            % Units of product Y (integer, non-negative)

var 0..(cost_x*capacity + cost_y*capacity): total_cost;  % Total production cost (bounded)

% Constraints
% Factory capacity: total produced units cannot exceed capacity
constraint
  x_units + y_units <= capacity;

% Demand requirement: combined contribution must meet or exceed minimum demand
constraint
  coeff_x * x_units + coeff_y * y_units >= demand_min;

% Cost accounting: total cost equals sum of per-unit costs times units produced
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;

output [
  "x_units = ", show(x_units), "\n",
  "y_units = ", show(y_units), "\n",
  "total_cost = $", show(total_cost), "\n"
];