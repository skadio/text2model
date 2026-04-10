% Parameters
int: min_total_classes = 50;
int: cost_math = 4;
int: cost_science = 3;
int: max_math_minus_science = 20;

% Variables
var 0..1000: X; % Math classes
var 0..1000: Y; % Science classes
var 0..1000000: total_cost;

% Constraints
constraint X + Y >= min_total_classes;
constraint X <= 2 * Y;
constraint X - Y <= max_math_minus_science;

constraint total_cost = cost_math * X + cost_science * Y;

% Objective
solve minimize total_cost;