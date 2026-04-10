% Parameters
int: total_budget = 1000;                 % Maximum total allocation across routes
int: min_2x_minus_y = 200;                % Minimum required for (2*X - Y)
int: max_yz_diff = 50;                    % Maximum allowed absolute difference |Y - Z|

int: cost_x = 10;                         % Cost per unit on route X
int: cost_y = 20;                         % Cost per unit on route Y
int: cost_z = 30;                         % Cost per unit on route Z

int: lb_x = 0; int: ub_x = total_budget;  % Bounds for route X allocation
int: lb_y = 0; int: ub_y = total_budget;  % Bounds for route Y allocation
int: lb_z = 0; int: ub_z = total_budget;  % Bounds for route Z allocation


% Variables
var lb_x..ub_x: alloc_x;                  % Units allocated to route X (integer)
var lb_y..ub_y: alloc_y;                  % Units allocated to route Y (integer)
var lb_z..ub_z: alloc_z;                  % Units allocated to route Z (integer)

% Total cost upper bound based on max allocations (safe, albeit loose)
var 0..(cost_x*ub_x + cost_y*ub_y + cost_z*ub_z): total_cost;


% Constraints
% Budget capacity constraint: total allocation across all routes within budget
constraint
  alloc_x + alloc_y + alloc_z <= total_budget;

% Service quality / policy constraint: ensure 2*X - Y is at least the required minimum
constraint
  2 * alloc_x - alloc_y >= min_2x_minus_y;

% Balance constraint: keep allocations on Y and Z within the allowed difference
constraint
  abs(alloc_y - alloc_z) <= max_yz_diff;

% Total cost definition: link total_cost to allocations and per-unit costs
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