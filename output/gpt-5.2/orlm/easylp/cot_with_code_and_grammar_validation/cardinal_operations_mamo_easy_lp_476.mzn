% Parameters
int: total_budget_max = 200;
int: x_max = 150;
int: y_max = 100;

float: impact_x = 0.6;
float: impact_y = 0.8;
int: impact_min = 120;

int: diff_xy_max = 50; % X - Y <= 50

int: cost_x = 50;
int: cost_y = 80;

% Variables
var 0..x_max: X;
var 0..y_max: Y;

% Constraints
constraint X + Y <= total_budget_max;

constraint impact_x * int2float(X) + impact_y * int2float(Y) >= int2float(impact_min);

constraint X - Y <= diff_xy_max;

% Objective
solve minimize cost_x * X + cost_y * Y;