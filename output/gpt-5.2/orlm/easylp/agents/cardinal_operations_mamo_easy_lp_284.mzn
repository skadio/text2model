% Parameters
int: max_total_resources = 100;              % Total available resource units (cap on units)

int: cost_X = 500;                           % Cost per unit allocated to area X (dollars)
int: cost_Y = 300;                           % Cost per unit allocated to area Y (dollars)
int: cost_Z = 700;                           % Cost per unit allocated to area Z (dollars)

int: min_X = 20;                             % Minimum required units for X
int: min_Y = 30;                             % Minimum required units for Y
int: min_Z = 10;                             % Minimum required units for Z

% Variables
var min_X..max_total_resources: x;           % Integer units allocated to area X
var min_Y..max_total_resources: y;           % Integer units allocated to area Y
var min_Z..max_total_resources: z;           % Integer units allocated to area Z

var 0..(cost_X*max_total_resources
      + cost_Y*max_total_resources
      + cost_Z*max_total_resources): total_cost;  % Total cost in dollars (bounded)

% Constraints
% Resource capacity constraint: total allocated units must not exceed the cap
constraint
  x + y + z <= max_total_resources;

% Minimum allocation constraints (reinforce variable lower bounds for clarity)
constraint x >= min_X;
constraint y >= min_Y;
constraint z >= min_Z;

% Relative allocation constraints between areas
% x >= 2*(x - y)  <=>  2*y >= x
constraint
  2 * y >= x;

% y >= 2*(y - z)  <=>  2*z >= y
constraint
  2 * z >= y;

% Total cost definition
constraint
  total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;