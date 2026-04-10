% Parameters
int: min_perf = 10;          % 3X + Y >= 10
int: max_capacity = 20;      % 2X + 4Y <= 20
int: cost_x = 4;
int: cost_y = 6;

% Variable bounds (derived from nonnegativity and capacity constraint)
int: X_ub = max_capacity div 2;  % since 2X <= 20
int: Y_ub = max_capacity div 4;  % since 4Y <= 20

% Variables
var 0..X_ub: X;   % Network Upgrade (integer)
var 0..Y_ub: Y;   % Security Enhancement (integer)
var 0..(cost_x * X_ub + cost_y * Y_ub): total_cost;

% Constraints
constraint 3 * X + Y >= min_perf;
constraint 2 * X + 4 * Y <= max_capacity;
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;