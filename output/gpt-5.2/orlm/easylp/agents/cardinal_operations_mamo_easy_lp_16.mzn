% Parameters
int: min_total_allocation = 50;          % Minimum total allocation required (X + Y >= 50)
int: max_balanced_expr = 30;             % Upper bound for balanced portfolio constraint (2X - Y <= 30)
int: cost_X = 4;                         % Cost per unit allocated to project X
int: cost_Y = 3;                         % Cost per unit allocated to project Y

% Upper bounds derived from constraints and non-negativity:
% From 2X - Y <= 30 and Y >= 0 => X <= 15
int: ub_X = 15;
% From X + Y >= 50 and X >= 0 with minimization => it is sufficient to bound Y by 50
int: ub_Y = 50;

% Variables
var 0..ub_X: x;                          % Integer units allocated to project X
var 0..ub_Y: y;                          % Integer units allocated to project Y
var 0..(cost_X * ub_X + cost_Y * ub_Y): total_cost; % Total cost (bounded)

% Constraints
% --- Minimum total allocation requirement ---
constraint x + y >= min_total_allocation;

% --- Balanced portfolio constraint ---
constraint 2 * x - y <= max_balanced_expr;

% --- Define total cost from allocations ---
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;