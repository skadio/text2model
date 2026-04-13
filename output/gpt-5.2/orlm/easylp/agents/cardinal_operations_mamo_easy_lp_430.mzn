% Parameters
int: total_capacity = 20;                 % Maximum combined resources for X and Y
int: min_demand = 10;                     % Minimum required demand level
int: balance_limit = 15;                  % Maximum allowed value for (2*X - Y)
int: cost_x = 5;                          % Cost per unit of X
int: cost_y = 4;                          % Cost per unit of Y

% Variables
var 0..total_capacity: x;                 % Integer units allocated to service X
var 0..total_capacity: y;                 % Integer units allocated to service Y
var 0..(cost_x*total_capacity + cost_y*total_capacity): total_cost; % Total cost bound

% Constraints
% Capacity constraint: total allocation cannot exceed available capacity
constraint x + y <= total_capacity;

% Demand constraint: ensure sufficient combined service level
constraint x + 2 * y >= min_demand;

% Balance constraint: limit operational imbalance between services
constraint 2 * x - y <= balance_limit;

% Cost definition: compute total cost from allocations
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;