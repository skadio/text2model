% Parameters
int: max_total_resources = 20;          % Maximum total units across X,Y,Z
int: min_feasibility = 5;              % Minimum required for 2*X + Y
int: max_quality_diff = 10;            % Maximum allowed for Y - Z

int: cost_X = 100;                     % Cost per unit for task X (design)
int: cost_Y = 200;                     % Cost per unit for task Y (construction)
int: cost_Z = 150;                     % Cost per unit for task Z (inspection)

% Variables
var 0..max_total_resources: X;         % Resource units allocated to task X (integer, non-negative)
var 0..max_total_resources: Y;         % Resource units allocated to task Y (integer, non-negative)
var 0..max_total_resources: Z;         % Resource units allocated to task Z (integer, non-negative)

var 0..(cost_X*max_total_resources + cost_Y*max_total_resources + cost_Z*max_total_resources): total_cost;
                                        % Total cost upper bound: allocating max_total_resources to each task

% Constraints
% Resource budget constraint: total allocated units cannot exceed the maximum
constraint
  X + Y + Z <= max_total_resources;

% Feasibility constraint: ensure sufficient resources for (2*X + Y)
constraint
  2 * X + Y >= min_feasibility;

% Quality control constraint: difference between Y and Z is no more than allowed
constraint
  Y - Z <= max_quality_diff;

% Cost definition: total_cost equals the sum of per-task costs times allocated units
constraint
  total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;