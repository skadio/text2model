% Parameters
int: limit_2X_plus_Y = 200;
int: min_X_plus_3Y = 150;
int: max_diff_XY = 20;

int: costX = 100;
int: costY = 50;

% Variables
var 0..200: X;
var 0..200: Y;

var 0..(costX*200 + costY*200): total_cost;

% Constraints
constraint 2*X + Y <= limit_2X_plus_Y;
constraint X + 3*Y >= min_X_plus_3Y;
constraint abs(X - Y) <= max_diff_XY;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;