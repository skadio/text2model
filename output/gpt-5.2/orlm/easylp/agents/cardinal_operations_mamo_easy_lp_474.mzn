% Parameters
% Resource and policy limits (embedded from the problem statement)
int: max_total_tours = 50;          % X + Y <= 50
int: min_weighted_balance = 40;     % 2X + 4Y >= 40
int: max_diversity_expr = 60;       % 3X - Y <= 60

% Costs per tour type (USD)
int: cost_X = 500;                 % cost per unit of Tour X
int: cost_Y = 1000;                % cost per unit of Tour Y


% Variables
var 0..max_total_tours: x;         % number of Tour X (integer, nonnegative, bounded by total limit)
var 0..max_total_tours: y;         % number of Tour Y (integer, nonnegative, bounded by total limit)

% Total cost (bounded by worst case: all tours at max cost)
var 0..(cost_X*max_total_tours + cost_Y*max_total_tours): total_cost;


% Constraints
%--- Total tours resource limit ---
constraint x + y <= max_total_tours;

%--- Minimum weighted balance requirement ---
constraint 2 * x + 4 * y >= min_weighted_balance;

%--- Diversity expression upper bound ---
constraint 3 * x - y <= max_diversity_expr;

%--- Link total_cost to decision variables and unit costs ---
constraint total_cost = cost_X * x + cost_Y * y;


% Objective
solve minimize total_cost;