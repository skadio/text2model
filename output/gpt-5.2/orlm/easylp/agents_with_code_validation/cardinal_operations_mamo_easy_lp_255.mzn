% Parameters
int: cost_x1 = 5;              % Unit cost for process x1
int: cost_x2 = 4;              % Unit cost for process x2
int: cost_x3 = 6;              % Unit cost for process x3

int: max_x1_x2 = 100;          % Upper bound on x1 + x2
int: min_2x1_3x3 = 150;        % Lower bound on 2*x1 + 3*x3
int: max_4x2_minus_x3 = 200;   % Upper bound on 4*x2 - x3

% Note: No explicit per-variable upper bounds are provided in the prompt,
% so we only enforce non-negativity (with generous upper bounds for safety).

% Variables
var 0..1000000: x1;            % Integer allocation to process x1 (non-negative)
var 0..1000000: x2;            % Integer allocation to process x2 (non-negative)
var 0..1000000: x3;            % Integer allocation to process x3 (non-negative)

var 0..1000000000: total_cost; % Total cost objective value

% Constraints
% Combined allocation constraint: x1 + x2 <= 100
constraint x1 + x2 <= max_x1_x2;

% Minimum requirement: 2*x1 + 3*x3 >= 150
constraint 2 * x1 + 3 * x3 >= min_2x1_3x3;

% Capacity/balancing: 4*x2 - x3 <= 200
constraint 4 * x2 - x3 <= max_4x2_minus_x3;

% Define total cost
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;