% Parameters
int: total_resources = 1000;   % Total resources available (overall limit)
int: cost_X = 5;               % Cost per resource for warehouse X ($)
int: cost_Y = 10;              % Cost per resource for warehouse Y ($)
int: cost_Z = 7;               % Cost per resource for warehouse Z ($)

int: min_X = 200;              % Minimum resources required for X
int: max_Y = 400;              % Maximum resources allowed for Y
int: min_Z = 150;              % Minimum resources required for Z

% Variables
var min_X..total_resources: x;  % Resources allocated to warehouse X
var 0..max_Y: y;                % Resources allocated to warehouse Y
var min_Z..total_resources: z;  % Resources allocated to warehouse Z

% Upper bound: assume all resources could be allocated at the most expensive rate (safe bound)
var 0..(cost_X*total_resources + cost_Y*total_resources + cost_Z*total_resources): total_cost;

% Constraints
% Do not exceed total resources available
constraint x + y + z <= total_resources;

% Define total cost
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];