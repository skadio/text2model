% Parameters
int: total_hours_max = 40;
int: min_effort = 20;                 % 2*x + y >= 20
int: diff_max = 10;                   % |x - y| <= 10
int: cost_x = 8;
int: cost_y = 10;
int: x_max = 25;
int: y_max = 15;

% Variables
var 0..x_max: x;
var 0..y_max: y;
var 0..(cost_x * x_max + cost_y * y_max): total_cost;

% Constraints
constraint x + y <= total_hours_max;
constraint 2 * x + y >= min_effort;
constraint abs(x - y) <= diff_max;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;