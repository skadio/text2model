% Parameters
int: max_total_resources = 1000;          % Total available resources (budget cap)
int: min_service_requirement = 500;       % Minimum service level requirement: 2*X + Y >= 500
int: cost_per_unit_x = 5;                 % Cost per unit allocated to center X
int: cost_per_unit_y = 7;                 % Cost per unit allocated to center Y

% Variables
var 0..max_total_resources: alloc_x;      % Integer allocation to distribution center X
var 0..max_total_resources: alloc_y;      % Integer allocation to distribution center Y
var 0..(cost_per_unit_x*max_total_resources + cost_per_unit_y*max_total_resources): total_cost;
                                          % Total cost in dollars (bounded)

% Constraints
% --- Resource availability constraint (budget cap) ---
constraint alloc_x + alloc_y <= max_total_resources;

% --- Minimum network service level constraint ---
constraint 2 * alloc_x + alloc_y >= min_service_requirement;

% --- Total cost definition constraint ---
constraint total_cost = cost_per_unit_x * alloc_x + cost_per_unit_y * alloc_y;

% Objective
solve minimize total_cost;

% (Optional) Output for inspection
output [
  "alloc_x = ", show(alloc_x), "\n",
  "alloc_y = ", show(alloc_y), "\n",
  "total_cost = ", show(total_cost), "\n"
];