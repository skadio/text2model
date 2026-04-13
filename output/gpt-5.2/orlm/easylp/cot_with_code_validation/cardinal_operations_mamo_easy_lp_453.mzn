% Parameters
int: limit_2x_plus_y = 200;
int: min_x_plus_3y = 150;
int: max_diff = 20;

int: cost_x = 100;
int: cost_y = 50;

% Variables
var 0..200: X;
var 0..200: Y;
var 0..(cost_x*200 + cost_y*200): total_cost;

% Constraints
constraint 2*X + Y <= limit_2x_plus_y;
constraint X + 3*Y >= min_x_plus_3y;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_x*X + cost_y*Y;

% Objective
solve minimize total_cost;