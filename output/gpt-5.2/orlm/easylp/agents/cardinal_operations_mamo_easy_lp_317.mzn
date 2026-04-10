% Parameters
int: total_capacity = 100;            % Maximum total allocation across routes X, Y, Z
int: min_diff_X_over_Y = 10;          % X must be at least this much more than Y
int: max_YZ = 70;                     % Maximum combined allocation for Y and Z

int: cost_X = 5;                      % Cost per unit allocated to route X
int: cost_Y = 3;                      % Cost per unit allocated to route Y
int: cost_Z = 4;                      % Cost per unit allocated to route Z

% Variables
var 0..total_capacity: x;             % Integer allocation to route X
var 0..total_capacity: y;             % Integer allocation to route Y
var 0..total_capacity: z;             % Integer allocation to route Z

var 0..(cost_X*total_capacity + cost_Y*total_capacity + cost_Z*total_capacity): total_cost;
                                      % Total cost (integer)

% Constraints
% Capacity constraint: total allocation across all routes cannot exceed fleet capacity
constraint
  x + y + z <= total_capacity;

% Balance constraint: route X allocation must be at least 10 more than route Y
constraint
  x >= y + min_diff_X_over_Y;

% Time constraint: combined allocation for routes Y and Z cannot exceed the limit
constraint
  y + z <= max_YZ;

% Cost definition constraint: compute total cost from allocations and unit costs
constraint
  total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;