% Parameters
int: min_total_classes = 50;
int: max_ratio_math_to_science = 2;     % X <= 2*Y
int: max_difference = 20;              % X - Y <= 20
int: cost_math = 4;
int: cost_science = 3;

% Variables
var 0..1000: X; % Math classes
var 0..1000: Y; % Science classes
var 0..1000000: total_cost;

% Constraints
constraint X + Y >= min_total_classes;
constraint X <= max_ratio_math_to_science * Y;
constraint X - Y <= max_difference;

constraint total_cost = cost_math * X + cost_science * Y;

% Objective
solve minimize total_cost;