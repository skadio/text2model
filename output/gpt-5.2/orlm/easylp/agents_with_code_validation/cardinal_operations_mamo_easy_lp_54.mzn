% Parameters
int: min_inventory_score = 10;        % Minimum required inventory score (x + 3y >= 10)
int: max_storage_limit   = 15;        % Maximum allowed storage usage (2x + y <= 15)
int: cost_x = 4;                      % Cost per unit of product category X
int: cost_y = 5;                      % Cost per unit of product category Y

% Variables
var 0..(max_storage_limit div 2): x;  % Units of X (non-negative); from 2x + y <= 15 => x <= 7
var 0..max_storage_limit: y;          % Units of Y (non-negative); from 2x + y <= 15 => y <= 15
var 0..(cost_x*(max_storage_limit div 2) + cost_y*max_storage_limit): total_cost; % Total cost

% Constraints
% Inventory score requirement: ensure sufficient inventory to meet demand
constraint x + 3 * y >= min_inventory_score;

% Storage capacity limit: ensure storage usage does not exceed capacity
constraint 2 * x + y <= max_storage_limit;

% Total cost definition
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;