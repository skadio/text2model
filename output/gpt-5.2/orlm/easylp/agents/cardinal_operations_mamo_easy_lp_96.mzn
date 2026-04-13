% Parameters
int: total_resource_cap = 100;          % Maximum total units available for sourcing + distribution
int: min_balance_requirement = 50;      % Minimum required value for 2*X + Y
int: max_difference = 30;              % Maximum allowed absolute difference |X - Y|
int: cost_per_unit_x = 2;              % Cost per unit for sourcing (X)
int: cost_per_unit_y = 3;              % Cost per unit for distribution (Y)

% Variables
var 0..total_resource_cap: x;          % Resource units allocated to sourcing (integer, non-negative)
var 0..total_resource_cap: y;          % Resource units allocated to distribution (integer, non-negative)
var 0..(cost_per_unit_x*total_resource_cap + cost_per_unit_y*total_resource_cap): total_cost;
                                       % Total cost to minimize (upper bound: all resources to both vars range max)

% Constraints
% Resource capacity constraint: total allocation cannot exceed available resources
constraint
  x + y <= total_resource_cap;

% Operational balance constraint: ensure sufficient combined weighted allocation
constraint
  2 * x + y >= min_balance_requirement;

% Reliance constraint: keep sourcing and distribution allocations within allowed difference
constraint
  abs(x - y) <= max_difference;

% Cost definition constraint: compute total cost from per-unit costs and allocations
constraint
  total_cost = cost_per_unit_x * x + cost_per_unit_y * y;

% Objective
solve minimize total_cost;