% Parameters
int: max_total_qty = 1000;          % Storage limit: x + y <= 1000
int: min_balance_rhs = 300;         % Balance requirement: x - 2y >= 300
int: min_demand_rhs = 500;          % Demand requirement: 3x + y >= 500

int: cost_x = 5;                    % Unit cost of product X
int: cost_y = 2;                    % Unit cost of product Y

int: x_lb = 0;                      % Lower bound for X
int: x_ub = 600;                    % Upper bound for X
int: y_lb = 0;                      % Lower bound for Y
int: y_ub = 500;                    % Upper bound for Y

% Variables
var x_lb..x_ub: x;                  % Quantity of product X (integer)
var y_lb..y_ub: y;                  % Quantity of product Y (integer)

var int: total_cost;                % Total cost = cost_x*x + cost_y*y

% Constraints
% Link total cost to decision variables
constraint
  total_cost = cost_x * x + cost_y * y;

% Storage capacity constraint: total quantity cannot exceed storage limit
constraint
  x + y <= max_total_qty;

% Inventory balance constraint: maintain required relationship between X and Y
constraint
  x - 2 * y >= min_balance_rhs;

% Demand constraint: ensure sufficient combined availability to meet demand
constraint
  3 * x + y >= min_demand_rhs;

% Objective
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];