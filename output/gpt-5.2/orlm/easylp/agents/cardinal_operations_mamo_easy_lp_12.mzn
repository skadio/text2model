% Parameters
int: max_total_alloc = 100;              % Maximum total resources available
int: min_effectiveness = 50;             % Minimum required effectiveness score
int: max_diff = 30;                      % Maximum allowed difference |X - Y|
int: eff_x = 2;                          % Effectiveness coefficient for project X
int: eff_y = 1;                          % Effectiveness coefficient for project Y
int: cost_x = 5;                         % Cost per unit allocated to project X
int: cost_y = 8;                         % Cost per unit allocated to project Y

% Variables
var 0..max_total_alloc: x_alloc;         % Integer resource allocation to project X
var 0..max_total_alloc: y_alloc;         % Integer resource allocation to project Y
var 0..(cost_x*max_total_alloc + cost_y*max_total_alloc): total_cost; % Total cost to minimize

% Constraints
% Budget constraint: total allocation cannot exceed available resources
constraint x_alloc + y_alloc <= max_total_alloc;

% Effectiveness constraint: meet minimum required effectiveness score
constraint eff_x * x_alloc + eff_y * y_alloc >= min_effectiveness;

% Balance constraint: allocation difference must be within allowed bound
constraint abs(x_alloc - y_alloc) <= max_diff;

% Cost definition: total cost equals cost per unit times allocations
constraint total_cost = cost_x * x_alloc + cost_y * y_alloc;

% Objective
solve minimize total_cost;