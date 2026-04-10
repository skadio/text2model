% Parameters
int: total_resource_cap = 100;              % Maximum total resource units across all projects
int: min_standard_requirement = 50;         % Minimum required combined effort for standard
int: balance_diff_cap = 20;                 % Maximum allowed difference between X and Z allocations

int: effort_x_coeff = 2;                    % Coefficient for X in the standard constraint
int: effort_y_coeff = 3;                    % Coefficient for Y in the standard constraint

int: cost_x = 5000;                         % Cost per unit allocated to project X
int: cost_y = 4000;                         % Cost per unit allocated to project Y
int: cost_z = 3000;                         % Cost per unit allocated to project Z

% Variables
var 0..total_resource_cap: alloc_x;         % Resource units allocated to project X (integer)
var 0..total_resource_cap: alloc_y;         % Resource units allocated to project Y (integer)
var 0..total_resource_cap: alloc_z;         % Resource units allocated to project Z (integer)

var 0..(cost_x*total_resource_cap + cost_y*total_resource_cap + cost_z*total_resource_cap): total_cost;
                                            % Total cost (integer dollars)

% Constraints
% Total resource capacity: sum of allocations cannot exceed the cap
constraint
  alloc_x + alloc_y + alloc_z <= total_resource_cap;

% Construction standard requirement: weighted effort from X and Y must meet minimum
constraint
  effort_x_coeff * alloc_x + effort_y_coeff * alloc_y >= min_standard_requirement;

% Balanced portfolio requirement: absolute difference between X and Z within limit
constraint
  abs(alloc_x - alloc_z) <= balance_diff_cap;

% Total cost definition: link total_cost to allocations and per-unit costs
constraint
  total_cost = cost_x * alloc_x + cost_y * alloc_y + cost_z * alloc_z;

% Objective
solve minimize total_cost;