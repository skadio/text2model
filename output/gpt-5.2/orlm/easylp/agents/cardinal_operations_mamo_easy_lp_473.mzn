% Parameters
int: max_total_resources = 200;          % Maximum combined allocation for X and Y
int: min_effectiveness = 150;            % Minimum required effectiveness score
int: max_allocation_diff = 50;           % Maximum allowed |X - Y|
int: eff_coef_X = 2;                     % Effectiveness coefficient for X
int: eff_coef_Y = 1;                     % Effectiveness coefficient for Y
int: cost_X = 50;                        % Cost per unit for strategy X
int: cost_Y = 80;                        % Cost per unit for strategy Y

% Variables
var 0..max_total_resources: x;           % Integer units allocated to strategy X
var 0..max_total_resources: y;           % Integer units allocated to strategy Y
var 0..(cost_X*max_total_resources + cost_Y*max_total_resources): total_cost; % Total cost (bounded)

% Constraints
% Budget/resource limit: total allocation cannot exceed the maximum available
constraint x + y <= max_total_resources;

% Minimum effectiveness requirement: weighted sum must reach the target
constraint eff_coef_X * x + eff_coef_Y * y >= min_effectiveness;

% Balance requirement: allocation difference must stay within allowed range
constraint abs(x - y) <= max_allocation_diff;

% Total cost definition: compute cost from allocations and unit costs
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];