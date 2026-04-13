% Parameters
int: capacity = 1000;                 % Maximum total production units
int: perf_min = 500;                  % Minimum required performance metric
int: portfolio_max = 400;             % Maximum allowed (X + Z - Y)

int: costX = 10;                      % Cost per unit of product X
int: costY = 15;                      % Cost per unit of product Y
int: costZ = 20;                      % Cost per unit of product Z

% Variables
var 0..capacity: x;                   % Units produced of product X (integer, non-negative)
var 0..capacity: y;                   % Units produced of product Y (integer, non-negative)
var 0..capacity: z;                   % Units produced of product Z (integer, non-negative)

var 0..(capacity * max([costX, costY, costZ])): total_cost;  % Total production cost (bounded)

% Constraints
% Capacity constraint: total production cannot exceed the plant capacity
constraint
  x + y + z <= capacity;

% Performance metric constraint: 5*X + 3*Y - Z must be at least the required minimum
constraint
  5 * x + 3 * y - z >= perf_min;

% Portfolio balance constraint: (X + Z - Y) must not exceed the specified maximum
constraint
  x + z - y <= portfolio_max;

% Total cost definition: compute total_cost from unit costs and production quantities
constraint
  total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;