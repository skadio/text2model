% Parameters (with values embedded)
int: capacity = 100;
int: x_max = 70;
int: y_max = 50;
int: cost_x = 50;
int: cost_y = 80;

% Variables
var 0..x_max: X;
var 0..y_max: Y;
var 0..(cost_x*x_max + cost_y*y_max): total_cost;

% Constraints
constraint X + Y <= capacity;

% X must be at least 10 more than twice Y: X >= 2Y + 10
constraint X >= 2*Y + 10;

% Difference between Y and half of X should not exceed 20:
% interpret as |Y - X/2| <= 20  ->  -20 <= 2Y - X <= 20
constraint 2*Y - X <= 20;
constraint 2*Y - X >= -20;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;