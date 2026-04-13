% Parameters
int: max_total_resources = 5000;          % Budget constraint: X + Y <= 5000
int: min_effectiveness = 10000;           % Requirement: 2*X + 3*Y >= 10000
int: eff_x = 2;                           % Effectiveness coefficient for strategy X
int: eff_y = 3;                           % Effectiveness coefficient for strategy Y
int: cost_x = 10;                         % Cost per unit of strategy X
int: cost_y = 20;                         % Cost per unit of strategy Y

% Variables
var 0..max_total_resources: x;            % Resources allocated to strategy X (integer, nonnegative)
var 0..max_total_resources: y;            % Resources allocated to strategy Y (integer, nonnegative)
var 0..(cost_x*max_total_resources + cost_y*max_total_resources): total_cost; % Total cost (bounded)

% Constraints
% Budget/resource capacity constraint
constraint x + y <= max_total_resources;

% Minimum effectiveness constraint
constraint eff_x * x + eff_y * y >= min_effectiveness;

% Total cost definition
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;