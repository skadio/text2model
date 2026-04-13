% Parameters
% Budget limit
int: max_budget = 1000;

% Minimum separation constraints
int: x_min_offset_over_2y = 200;   % X >= 2*Y + 200
int: z_min_offset_over_y  = 150;   % Z >= Y + 150

% Cost (weight) per dollar allocated
int: cost_x = 50;
int: cost_y = 30;
int: cost_z = 20;

% Allocation bounds (whole-number dollars)
int: x_lb = 0;
int: x_ub = max_budget;
int: y_lb = 0;
int: y_ub = max_budget;
int: z_lb = 0;
int: z_ub = max_budget;

% Variables
var x_lb..x_ub: alloc_x;  % Allocation to department X (General Medicine)
var y_lb..y_ub: alloc_y;  % Allocation to department Y (Pediatrics)
var z_lb..z_ub: alloc_z;  % Allocation to department Z (Surgery)

% Objective value (upper bound based on max spending everywhere, though budget caps it)
var 0..(cost_x*max_budget + cost_y*max_budget + cost_z*max_budget): total_cost;

% Constraints
% --- Budget feasibility: total allocations cannot exceed the available budget ---
constraint
  alloc_x + alloc_y + alloc_z <= max_budget;

% --- Department relationship constraints (minimum separations) ---
% X must be at least 200 more than twice Y: X >= 2*Y + 200
constraint
  alloc_x >= 2 * alloc_y + x_min_offset_over_2y;

% Z must exceed Y by at least 150: Z >= Y + 150
constraint
  alloc_z >= alloc_y + z_min_offset_over_y;

% --- Total cost definition (linear expression of allocations) ---
constraint
  total_cost = cost_x * alloc_x + cost_y * alloc_y + cost_z * alloc_z;

% Objective
solve minimize total_cost;

output [
  "alloc_x=", show(alloc_x), "\n",
  "alloc_y=", show(alloc_y), "\n",
  "alloc_z=", show(alloc_z), "\n",
  "total_cost=", show(total_cost), "\n"
];