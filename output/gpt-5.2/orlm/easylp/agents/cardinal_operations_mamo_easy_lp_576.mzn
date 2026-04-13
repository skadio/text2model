% Parameters
int: total_resources = 1000;          % Total resources available (budget limit)

int: cost_X = 5;                      % Cost per resource for warehouse X
int: cost_Y = 10;                     % Cost per resource for warehouse Y
int: cost_Z = 7;                      % Cost per resource for warehouse Z

int: min_X = 200;                     % Minimum resources required for X
int: max_Y = 400;                     % Maximum resources allowed for Y
int: min_Z = 150;                     % Minimum resources required for Z


% Variables
var min_X..total_resources: rX;        % Resources allocated to warehouse X (integer)
var 0..max_Y: rY;                      % Resources allocated to warehouse Y (integer)
var min_Z..total_resources: rZ;        % Resources allocated to warehouse Z (integer)

var 0..(cost_X*total_resources + cost_Y*total_resources + cost_Z*total_resources): total_cost;
                                      % Total cost (safe upper bound)


% Constraints
% Resource availability constraint: total allocated resources cannot exceed the limit
constraint
  rX + rY + rZ <= total_resources;

% Cost definition constraint: compute total cost from allocations and per-unit costs
constraint
  total_cost = cost_X * rX + cost_Y * rY + cost_Z * rZ;


% Objective
solve minimize total_cost;