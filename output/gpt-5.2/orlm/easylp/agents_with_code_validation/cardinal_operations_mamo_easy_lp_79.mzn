% Parameters
int: resource_limit = 60;          % Maximum total resource units available
int: resource_per_x = 2;           % Resource units needed per project X
int: resource_per_y = 3;           % Resource units needed per project Y
int: min_total_projects = 10;      % Minimum number of projects to complete

int: cost_x = 1000;                % Cost per project X (dollars)
int: cost_y = 500;                 % Cost per project Y (dollars)

% Helpful upper bounds derived from resource limit (for bounded variables)
int: max_x = resource_limit div resource_per_x;  % Max possible X if only X is done
int: max_y = resource_limit div resource_per_y;  % Max possible Y if only Y is done

% Variables
var 0..max_x: x_projects;          % Number of type X projects (integer, nonnegative)
var 0..max_y: y_projects;          % Number of type Y projects (integer, nonnegative)

var 0..(cost_x*max_x + cost_y*max_y): total_cost; % Total cost (bounded integer)

% Constraints

% Resource capacity constraint: total resources used by X and Y cannot exceed the limit
constraint
  resource_per_x * x_projects + resource_per_y * y_projects <= resource_limit;

% Minimum production constraint: total number of projects must meet the minimum requirement
constraint
  x_projects + y_projects >= min_total_projects;

% Total cost definition: link total_cost to the chosen numbers of projects
constraint
  total_cost = cost_x * x_projects + cost_y * y_projects;

% Objective
solve minimize total_cost;