% Parameters
int: max_total_tours = 50;          % Upper bound on total number of tours (X + Y)
int: min_balance_expr = 40;         % Minimum required for 2*X + 4*Y
int: max_diversity_expr = 60;       % Maximum allowed for 3*X - Y
int: cost_x = 500;                  % Cost per unit of Tour X (in dollars)
int: cost_y = 1000;                 % Cost per unit of Tour Y (in dollars)

% Variables
var 0..max_total_tours: x;          % Number of Tour X (integer, nonnegative, bounded)
var 0..max_total_tours: y;          % Number of Tour Y (integer, nonnegative, bounded)
var 0..(max_total_tours * max(cost_x, cost_y)): total_cost;  % Total cost (bounded)

% Constraints
% Resource limit: total number of tours cannot exceed available capacity
constraint x + y <= max_total_tours;

% Balance requirement: ensure sufficient combined "experience units"
constraint 2*x + 4*y >= min_balance_expr;

% Diversity cap: prevent an excessive skew toward tour X relative to Y
constraint 3*x - y <= max_diversity_expr;

% Cost definition: total cost equals sum of per-tour costs
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;