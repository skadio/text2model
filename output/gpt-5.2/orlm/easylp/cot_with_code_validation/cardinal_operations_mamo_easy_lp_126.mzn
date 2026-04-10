% Parameters
int: min_total_programs = 30;
int: diff_limit = 10;
int: costX = 4;
int: costY = 3;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..(costX*1000 + costY*1000): total_cost;

% Constraints
constraint X + Y >= min_total_programs;
constraint 2 * X - Y <= diff_limit;
constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;