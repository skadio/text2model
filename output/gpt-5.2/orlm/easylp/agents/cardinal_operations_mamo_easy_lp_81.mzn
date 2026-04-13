% Parameters
int: min_requirement = 200;          % Minimum required units for 2*X + 3*Y
int: max_balance = 300;              % Maximum allowed units for 4*X + Y
int: max_x = 100;                    % Upper bound on allocation to project X
int: max_y = 80;                     % Upper bound on allocation to project Y
int: cost_x = 500;                   % Cost per unit allocated to X (dollars)
int: cost_y = 600;                   % Cost per unit allocated to Y (dollars)

% Variables
var 0..max_x: x;                     % Integer units allocated to project X
var 0..max_y: y;                     % Integer units allocated to project Y
var 0..(cost_x*max_x + cost_y*max_y): total_cost; % Total cost (dollars)

% Constraints
% Link total_cost to allocations and per-unit costs
constraint total_cost = cost_x * x + cost_y * y;

% Minimum requirement: 2*X + 3*Y must be at least min_requirement
constraint 2 * x + 3 * y >= min_requirement;

% Balance/limit constraint: 4*X + Y must not exceed max_balance
constraint 4 * x + y <= max_balance;

% Project X allocation must be at least project Y allocation
constraint x >= y;

% Objective
solve minimize total_cost;