% Parameters
int: total_budget = 100;          % Maximum total resource units available
int: min_z_minus_x = 10;          % Z must be at least this many units more than X
int: cost_x = 10;                 % Cost per unit for project X
int: cost_y = 20;                 % Cost per unit for project Y
int: cost_z = 30;                 % Cost per unit for project Z

% Variables
var 0..total_budget: x;           % Integer units allocated to project X
var 0..total_budget: y;           % Integer units allocated to project Y
var 0..total_budget: z;           % Integer units allocated to project Z

% Total cost upper bound: all budget spent on all projects (loose but safe)
var 0..(cost_x*total_budget + cost_y*total_budget + cost_z*total_budget): total_cost;

% Constraints
% Budget constraint: total allocated resources cannot exceed the available budget
constraint x + y + z <= total_budget;

% Project relationship constraints:
% 1) X must be at least twice Y
constraint x >= 2 * y;

% 2) Z must be at least min_z_minus_x more than X
constraint z >= x + min_z_minus_x;

% Total cost definition: link total_cost to allocations and per-unit costs
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;