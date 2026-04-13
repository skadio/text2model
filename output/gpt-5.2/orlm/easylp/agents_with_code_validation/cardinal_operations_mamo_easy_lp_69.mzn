% Parameters
int: cost_x = 5;                  % Cost per unit of crop X
int: cost_y = 10;                 % Cost per unit of crop Y
int: min_yield = 200;             % Minimum required yield for 2*X + Y
int: max_resource = 150;          % Maximum allowed for X + 3*Y

% Variables
var 0..max_resource: x;           % Units of crop X (non-negative integer, bounded)
var 0..(max_resource div 3): y;   % Units of crop Y (non-negative integer, bounded)
var 0..(cost_x*max_resource + cost_y*(max_resource div 3)): total_cost; % Total planting cost

% Constraints
% Link total_cost to decision variables (linear cost accounting)
constraint total_cost = cost_x * x + cost_y * y;

% Minimum production quota: 2*X + Y must be at least min_yield
constraint 2 * x + y >= min_yield;

% Resource/processing limitation: X + 3*Y must be at most max_resource
constraint x + 3 * y <= max_resource;

% Objective
solve minimize total_cost;