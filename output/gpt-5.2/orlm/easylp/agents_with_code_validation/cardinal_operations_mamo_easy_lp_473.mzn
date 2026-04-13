% Parameters
int: budget_limit = 200;                 % Maximum total resources for X+Y
int: min_effectiveness = 150;            % Minimum required effectiveness
int: max_diff = 50;                      % Maximum allowed |X - Y|
int: eff_x = 2;                          % Effectiveness coefficient for X
int: eff_y = 1;                          % Effectiveness coefficient for Y
int: cost_x = 50;                        % Cost per unit of X
int: cost_y = 80;                        % Cost per unit of Y

% Variables
var 0..budget_limit: x;                  % Resources allocated to strategy X (integer, non-negative)
var 0..budget_limit: y;                  % Resources allocated to strategy Y (integer, non-negative)
var 0..(cost_x*budget_limit + cost_y*budget_limit): total_cost;  % Total cost (bounded)

% Constraints
% Budget constraint: total resources allocated cannot exceed the limit
constraint x + y <= budget_limit;

% Effectiveness constraint: ensure minimum required reach/effectiveness
constraint eff_x * x + eff_y * y >= min_effectiveness;

% Balance constraint: resource allocations must be within max_diff of each other
constraint abs(x - y) <= max_diff;

% Total cost definition: compute total cost from allocations
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;

% (Optional) Output the optimal plan and cost
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];