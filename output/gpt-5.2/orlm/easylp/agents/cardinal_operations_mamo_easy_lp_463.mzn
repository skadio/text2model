% Parameters
% Budget and capacity constraints (embedded as per instructions)
int: total_allocation_max = 5000;  % Total allocation across both warehouses cannot exceed this
int: x_allocation_min    = 1000;  % Minimum allocation required for warehouse X
int: y_allocation_max    = 3000;  % Maximum capacity for warehouse Y

% Unit costs (in dollars per unit)
int: cost_x = 50;                 % Cost per unit allocated to X
int: cost_y = 75;                 % Cost per unit allocated to Y


% Variables
var 0..total_allocation_max: alloc_x; % Integer units allocated to warehouse X
var 0..total_allocation_max: alloc_y; % Integer units allocated to warehouse Y

% Upper bound: worst-case if both were at total_allocation_max (safe bound)
var 0..(cost_x*total_allocation_max + cost_y*total_allocation_max): total_cost; % Total cost in dollars


% Constraints
% --- Allocation feasibility constraints ---
% Total resources allocated across both warehouses must respect the overall cap
constraint alloc_x + alloc_y <= total_allocation_max;

% Warehouse X must receive at least the minimum required allocation
constraint alloc_x >= x_allocation_min;

% Warehouse Y must not exceed its maximum capacity
constraint alloc_y <= y_allocation_max;

% --- Cost definition constraint ---
% Total cost is the linear combination of allocations and their unit costs
constraint total_cost = cost_x * alloc_x + cost_y * alloc_y;


% Objective
solve minimize total_cost;