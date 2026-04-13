% Parameters
int: capacity = 1000;                 % Maximum total units producible
int: demand_min = 600;                % Minimum required for 3*X + 4*Y
int: balance_max = 200;               % Maximum allowed for 5*Z - Y

int: costX = 50;                      % Cost per unit of product X
int: costY = 30;                      % Cost per unit of product Y
int: costZ = 20;                      % Cost per unit of product Z

% Variables
var 0..capacity: x;                   % Units of product X (integer, nonnegative)
var 0..capacity: y;                   % Units of product Y (integer, nonnegative)
var 0..capacity: z;                   % Units of product Z (integer, nonnegative)

var 0..(costX*capacity + costY*capacity + costZ*capacity): total_cost; % Total production cost ($)

% Constraints
% Capacity constraint: total production cannot exceed factory capacity
constraint x + y + z <= capacity;

% Demand constraint: ensure combined production meets minimum market requirement
constraint 3 * x + 4 * y >= demand_min;

% Balance constraint: maintain inventory balance (5*Z - Y must not exceed limit)
constraint 5 * z - y <= balance_max;

% Total cost definition: compute total production cost from unit costs and quantities
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;