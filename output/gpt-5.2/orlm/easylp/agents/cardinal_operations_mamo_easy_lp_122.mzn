% Parameters
int: total_budget_max = 40;        % Maximum combined allocation for programs X and Y
int: x_min = 15;                   % Minimum allocation for program X
int: y_min = 10;                   % Minimum allocation for program Y
int: x_max = 30;                   % Maximum allocation for program X
int: y_max = 20;                   % Maximum allocation for program Y
int: cost_per_unit_x = 10;         % Cost per unit for program X
int: cost_per_unit_y = 5;          % Cost per unit for program Y

% Variables
var x_min..x_max: alloc_x;         % Integer allocation to program X
var y_min..y_max: alloc_y;         % Integer allocation to program Y
var 0..(cost_per_unit_x*x_max + cost_per_unit_y*y_max): total_cost; % Total cost objective variable

% Constraints
% Budget feasibility: combined allocation cannot exceed the maximum total budget
constraint alloc_x + alloc_y <= total_budget_max;

% Total cost definition: compute total cost from allocations and per-unit costs
constraint total_cost = cost_per_unit_x * alloc_x + cost_per_unit_y * alloc_y;

% Objective
solve minimize total_cost;