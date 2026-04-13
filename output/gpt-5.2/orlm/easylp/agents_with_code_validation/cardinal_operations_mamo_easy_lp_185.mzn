% Parameters
int: cost_X = 50;                  % Cost per unit of product X
int: cost_Y = 30;                  % Cost per unit of product Y
int: cost_Z = 20;                  % Cost per unit of product Z

int: max_total_units = 500;        % Upper bound on total production X+Y+Z
int: min_weighted_output = 100;    % Lower bound on 3X - Y + Z
int: max_balance_expr = 200;       % Upper bound on X - 2Y - Z


% Variables
var 0..max_total_units: x;         % Integer units of product X
var 0..max_total_units: y;         % Integer units of product Y
var 0..max_total_units: z;         % Integer units of product Z

% Total production cost (safe upper bound)
var 0..(cost_X*max_total_units + cost_Y*max_total_units + cost_Z*max_total_units): total_cost;


% Constraints
% --- Capacity/Budget limit: total production cannot exceed available units ---
constraint x + y + z <= max_total_units;

% --- Demand / throughput requirement: weighted output must meet minimum ---
constraint 3 * x - y + z >= min_weighted_output;

% --- Balance / logistics constraint: linear expression must not exceed limit ---
constraint x - 2 * y - z <= max_balance_expr;

% --- Total cost definition: link decision variables to total_cost ---
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;


% Objective
solve minimize total_cost;

% (Optional) Output for inspection
output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];