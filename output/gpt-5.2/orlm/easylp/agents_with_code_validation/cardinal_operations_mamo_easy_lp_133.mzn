% Parameters
int: max_weighted_resources = 1000;      % Upper bound on 2*X + 3*Y
int: weight_x = 2;                       % Resource weight per unit of Project X
int: weight_y = 3;                       % Resource weight per unit of Project Y
int: min_diff_xy = 100;                  % Enforce X >= Y + 100
int: cost_per_x = 5;                     % Cost contribution per unit of X
int: cost_per_y = 7;                     % Cost contribution per unit of Y

% Variables
var 0..max_weighted_resources: x;        % Integer units allocated to Project X
var 0..max_weighted_resources: y;        % Integer units allocated to Project Y
var 0..(cost_per_x*max_weighted_resources + cost_per_y*max_weighted_resources): total_cost; % Total cost to minimize

% Constraints
% --- Weighted resource capacity (2*X + 3*Y <= 1000) ---
constraint weight_x * x + weight_y * y <= max_weighted_resources;

% --- Balance constraint (X at least 100 more than Y) ---
constraint x >= y + min_diff_xy;

% --- Define total cost from allocations ---
constraint total_cost = cost_per_x * x + cost_per_y * y;

% Objective
solve minimize total_cost;