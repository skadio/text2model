% Parameters
% Budget constraints
int: max_total_allocation = 200;      % Maximum allowed total allocation for X + Y
int: min_total_allocation = 50;       % Minimum required total allocation for X + Y

% Unit costs
int: cost_per_unit_X = 5;             % Cost per unit allocated to project X
int: cost_per_unit_Y = 8;             % Cost per unit allocated to project Y


% Variables
var 0..max_total_allocation: alloc_X; % Integer allocation (units) to project X
var 0..max_total_allocation: alloc_Y; % Integer allocation (units) to project Y

% Total cost (bounded using worst-case maximum allocation for both variables)
var 0..(cost_per_unit_X * max_total_allocation + cost_per_unit_Y * max_total_allocation): total_cost;


% Constraints
% Total allocation bounds (budget feasibility)
constraint alloc_X + alloc_Y <= max_total_allocation;
constraint alloc_X + alloc_Y >= min_total_allocation;

% Total cost definition (linear cost from allocations)
constraint total_cost = cost_per_unit_X * alloc_X + cost_per_unit_Y * alloc_Y;


% Objective
solve minimize total_cost;