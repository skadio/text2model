% Parameters
int: total_capacity = 1000;                 % Maximum combined units available (X + Y)
int: min_weighted_allocation = 800;         % Minimum required for 2*X + Y
int: max_balance_diff = 200;                % Maximum allowed difference |X - Y|
int: cost_x = 4;                            % Cost per unit allocated to warehouse X
int: cost_y = 3;                            % Cost per unit allocated to warehouse Y

% Variables
var 0..total_capacity: x;                   % Integer units allocated to warehouse X
var 0..total_capacity: y;                   % Integer units allocated to warehouse Y
var 0..(cost_x*total_capacity + cost_y*total_capacity): total_cost; % Total cost (upper bound: 7000)

% Constraints
% Capacity constraint: total allocation cannot exceed available capacity
constraint x + y <= total_capacity;

% Minimum operational requirement: weighted allocation must meet threshold
constraint 2 * x + y >= min_weighted_allocation;

% Balance constraint: keep allocations within the allowed difference
constraint abs(x - y) <= max_balance_diff;

% Cost definition: compute total cost from unit costs and allocations
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;