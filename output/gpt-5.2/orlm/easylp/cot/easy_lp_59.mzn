% Parameters (with values embedded)
int: min_perf = 10;          % 3*X + Y >= 10
int: max_capacity = 20;      % 2*X + 4*Y <= 20
int: cost_X = 4;             % cost per unit of X
int: cost_Y = 6;             % cost per unit of Y

% Variables
var 0..10: X;                % Network Upgrade (bounded via capacity: 2*X <= 20)
var 0..5: Y;                 % Security Enhancement (bounded via capacity: 4*Y <= 20)

% Constraints
constraint 3*X + Y >= min_perf;
constraint 2*X + 4*Y <= max_capacity;

% Objective
var int: total_cost = cost_X*X + cost_Y*Y;
solve minimize total_cost;