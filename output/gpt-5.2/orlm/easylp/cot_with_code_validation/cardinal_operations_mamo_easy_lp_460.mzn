% Parameters
int: total_hours = 40;
int: min_effort = 20;          % 2*X + Y >= min_effort
int: max_diff = 10;            % |X - Y| <= max_diff
int: cost_x = 8;
int: cost_y = 10;
int: max_x = 25;
int: max_y = 15;

% Variables
var 0..max_x: x;               % hours for Task X (integer)
var 0..max_y: y;               % hours for Task Y (integer)
var 0..(cost_x*max_x + cost_y*max_y): total_cost;

% Constraints
constraint x + y <= total_hours;
constraint 2*x + y >= min_effort;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;