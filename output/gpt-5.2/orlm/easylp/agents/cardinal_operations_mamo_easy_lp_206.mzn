% Parameters
int: total_capacity = 150;          % Maximum total units that can be allocated
int: min_diff_XY = 10;              % X must be at least this many units more than Y
int: max_diff_YZ = 20;              % Y can be at most this many units more than Z

int: cost_X = 100;                  % Cost per unit allocated to department X
int: cost_Y = 50;                   % Cost per unit allocated to department Y
int: cost_Z = 30;                   % Cost per unit allocated to department Z


% Variables
var 0..total_capacity: alloc_X;     % Integer units allocated to department X
var 0..total_capacity: alloc_Y;     % Integer units allocated to department Y
var 0..total_capacity: alloc_Z;     % Integer units allocated to department Z

var 0..(cost_X*total_capacity + cost_Y*total_capacity + cost_Z*total_capacity): total_cost;
                                   % Total cost (bounded using worst-case upper bound)


% Constraints
% Capacity constraint: total allocation across all departments cannot exceed budgeted capacity
constraint
  alloc_X + alloc_Y + alloc_Z <= total_capacity;

% Department relation constraints: enforce minimum/maximum differences between allocations
constraint
  alloc_X >= alloc_Y + min_diff_XY;     % X must be at least min_diff_XY more than Y

constraint
  alloc_Y <= alloc_Z + max_diff_YZ;     % Y can be at most max_diff_YZ more than Z

% Cost definition constraint: compute total cost from allocations and unit costs
constraint
  total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;


% Objective
solve minimize total_cost;