% Parameters
int: max_total_allocation = 1000;        % Budget/resource cap: X + Y <= 1000
int: min_service_requirement = 500;      % Service requirement: 2*X + Y >= 500
int: cost_per_unit_x = 5;                % Cost per unit allocated to center X
int: cost_per_unit_y = 7;                % Cost per unit allocated to center Y

% Variables
var 0..max_total_allocation: alloc_x;    % Integer units allocated to center X
var 0..max_total_allocation: alloc_y;    % Integer units allocated to center Y
var 0..(cost_per_unit_x*max_total_allocation + cost_per_unit_y*max_total_allocation): total_cost;
% Total cost in dollars (bounded)

% Constraints
% Total allocation must respect the overall resource/budget cap
constraint alloc_x + alloc_y <= max_total_allocation;

% Minimum service level requirement across the network
constraint 2 * alloc_x + alloc_y >= min_service_requirement;

% Define total cost based on per-unit costs and allocations
constraint total_cost = cost_per_unit_x * alloc_x + cost_per_unit_y * alloc_y;

% Objective
solve minimize total_cost;