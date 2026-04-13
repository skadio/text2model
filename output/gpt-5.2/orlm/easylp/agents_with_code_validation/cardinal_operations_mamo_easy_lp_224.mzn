% Parameters
int: budget_limit = 1000;                 % Maximum total resource units across X,Y,Z
int: min_rule1 = 500;                     % Minimum for 2*X + Y
int: max_rule2 = 800;                     % Maximum for X + 3*Z

int: cost_x = 10;                         % Cost per unit for project X
int: cost_y = 15;                         % Cost per unit for project Y
int: cost_z = 20;                         % Cost per unit for project Z

% Variables
var 0..budget_limit: x;                   % Resource units allocated to project X
var 0..budget_limit: y;                   % Resource units allocated to project Y
var 0..budget_limit: z;                   % Resource units allocated to project Z

% Upper bound: all budget spent on the most expensive unit costs (safe bound)
var 0..(cost_x*budget_limit + cost_y*budget_limit + cost_z*budget_limit): total_cost;

% Constraints
% Budget limit on total allocated resource units
constraint x + y + z <= budget_limit;

% Strategic rule 1: ensure sufficient combined effort of X and Y
constraint 2 * x + y >= min_rule1;

% Strategic rule 2: limit combined effort of X and Z
constraint x + 3 * z <= max_rule2;

% Define total cost from allocations and per-unit costs
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;