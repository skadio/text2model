% Parameters (with values embedded)
int: max_weighted_resources = 50;          % 2*X + 3*Y <= 50
int: min_total_resources = 10;             % X + Y >= 10
int: max_difference = 20;                  % |X - Y| <= 20
int: cost_per_unit_X = 100;
int: cost_per_unit_Y = 200;

% Variable bounds derived from constraints:
% X + Y >= 10 and nonnegativity => X,Y <= 50 (safe upper bound), but we can tighten:
% 2*X <= 50 => X <= 25; 3*Y <= 50 => Y <= 16
int: X_ub = 25;
int: Y_ub = 16;

% Variables
var 0..X_ub: X;
var 0..Y_ub: Y;
var 0..(cost_per_unit_X * X_ub + cost_per_unit_Y * Y_ub): total_cost;

% Constraints
constraint 2*X + 3*Y <= max_weighted_resources;
constraint X + Y >= min_total_resources;
constraint abs(X - Y) <= max_difference;

constraint total_cost = cost_per_unit_X * X + cost_per_unit_Y * Y;

% Objective
solve minimize total_cost;