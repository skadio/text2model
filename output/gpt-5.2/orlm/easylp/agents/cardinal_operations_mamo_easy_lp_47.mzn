% Parameters
int: min_total_resources = 100;           % Minimum required total resources (X + Y)
int: max_weighted_resources = 250;        % Maximum allowed weighted resources (2*X + Y)
int: cost_X = 50;                         % Cost per unit resource for department X
int: cost_Y = 80;                         % Cost per unit resource for department Y

% Variables
var 0..max_weighted_resources: x;         % Resources allocated to department X (non-negative integer)
var 0..max_weighted_resources: y;         % Resources allocated to department Y (non-negative integer)
var 0..(cost_X*max_weighted_resources + cost_Y*max_weighted_resources): total_cost; % Total cost (bounded)

% Constraints
% Minimum total resources requirement
constraint x + y >= min_total_resources;

% Maximum weighted resources availability (2*X + Y)
constraint 2 * x + y <= max_weighted_resources;

% Total cost definition based on per-unit costs
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];