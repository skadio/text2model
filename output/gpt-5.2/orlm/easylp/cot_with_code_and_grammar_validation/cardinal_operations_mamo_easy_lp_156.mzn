% Parameters
int: total_max = 100;
int: x_min = 30;
int: x_max = 70;
int: y_min = 20;
int: y_max = 80;
int: cost_x = 5000;
int: cost_y = 3000;

% Variables
var x_min..x_max: X;
var y_min..y_max: Y;

% Constraints
constraint X + Y <= total_max;

% Objective
solve minimize cost_x * X + cost_y * Y;