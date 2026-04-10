% Parameters (with values embedded)
int: total_group_limit = 20;
int: min_diversity = 10;          % 2*X + Y >= 10
int: max_diff = 5;               % |X - Y| <= 5
int: costX = 100;
int: costY = 50;
int: maxX = 15;
int: maxY = 10;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint X + Y <= total_group_limit;
constraint 2*X + Y >= min_diversity;
constraint abs(X - Y) <= max_diff;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;