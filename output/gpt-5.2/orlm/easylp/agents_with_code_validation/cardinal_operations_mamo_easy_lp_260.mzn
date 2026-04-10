% Parameters
int: total_allocation_max = 1000;     % Total allocation across X,Y,Z cannot exceed this
int: x_min_more_than_y = 200;         % X must be at least this many units more than Y
int: z_min_more_than_y = 50;          % Z must be at least this many units more than Y

int: cost_x = 4;                      % Cost per unit allocated to X
int: cost_y = 5;                      % Cost per unit allocated to Y
int: cost_z = 6;                      % Cost per unit allocated to Z

% Variables
var 0..total_allocation_max: alloc_x; % Integer allocation to division X
var 0..total_allocation_max: alloc_y; % Integer allocation to division Y
var 0..total_allocation_max: alloc_z; % Integer allocation to division Z

% Upper bound: worst-case if all 1000 units were assigned to each division in the expression
var 0..(cost_x*total_allocation_max + cost_y*total_allocation_max + cost_z*total_allocation_max): total_cost;

% Constraints
% --- Total allocation budget constraint ---
constraint
  alloc_x + alloc_y + alloc_z <= total_allocation_max;

% --- Relative viability constraints between divisions ---
constraint
  alloc_x >= alloc_y + x_min_more_than_y;

constraint
  alloc_z >= alloc_y + z_min_more_than_y;

% --- Total cost definition constraint ---
constraint
  total_cost = cost_x * alloc_x + cost_y * alloc_y + cost_z * alloc_z;

% Objective
solve minimize total_cost;