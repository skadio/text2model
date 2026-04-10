% Parameters
int: max_total_groups = 20;
int: min_mix_requirement = 10;          % 2*X + Y >= 10
int: max_diff = 5;                      % |X - Y| <= 5
int: cost_x = 100;
int: cost_y = 50;
int: max_x = 15;
int: max_y = 10;

% Variables
var 0..max_x: X;
var 0..max_y: Y;
var 0..(cost_x * max_x + cost_y * max_y): total_cost;

% Constraints
constraint X + Y <= max_total_groups;
constraint 2 * X + Y >= min_mix_requirement;
constraint abs(X - Y) <= max_diff;
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;