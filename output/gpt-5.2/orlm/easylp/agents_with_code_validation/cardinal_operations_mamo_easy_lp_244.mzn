% Parameters
int: total_resource_limit = 100;              % Max total allocation across X,Y,Z
int: min_standard_requirement = 50;           % Minimum required combined effort
int: max_diff_x_z = 20;                       % Maximum allowed |X - Z|

int: coeff_x_in_standard = 2;                 % Coefficient of X in standard constraint
int: coeff_y_in_standard = 3;                 % Coefficient of Y in standard constraint

int: cost_x = 5000;                           % Cost per unit allocated to X
int: cost_y = 4000;                           % Cost per unit allocated to Y
int: cost_z = 3000;                           % Cost per unit allocated to Z

% Variables
var 0..total_resource_limit: x;               % Units allocated to project X
var 0..total_resource_limit: y;               % Units allocated to project Y
var 0..total_resource_limit: z;               % Units allocated to project Z

var 0..total_resource_limit: abs_diff_x_z;    % Auxiliary for |x - z| (bounded by total limit)

var 0..(cost_x*total_resource_limit + cost_y*total_resource_limit + cost_z*total_resource_limit): total_cost;
                                              % Total cost (upper bound when all at limit)

% Constraints
% Resource budget: total allocation across all projects cannot exceed the limit
constraint
  x + y + z <= total_resource_limit;

% Construction standard: combined effort from X and Y must meet the minimum requirement
constraint
  coeff_x_in_standard * x + coeff_y_in_standard * y >= min_standard_requirement;

% Balanced portfolio: define and limit the absolute difference between X and Z
constraint
  abs_diff_x_z = abs(x - z);
constraint
  abs_diff_x_z <= max_diff_x_z;

% Total cost calculation from per-unit costs and allocated units
constraint
  total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "abs_diff_x_z=", show(abs_diff_x_z), "\n",
  "total_cost=", show(total_cost), "\n"
];