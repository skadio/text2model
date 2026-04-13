% Parameters
int: budget_max = 5000;
int: x_max = 2500;
int: y_max = 1500;
int: z_max = 4000;

int: x_at_least_more_than_y = 50;
int: z_x_diff_min = 200;
int: z_x_diff_max = 1000;
int: z_y_diff_min = 200;
int: z_y_diff_max = 1000;

int: cost_x = 500;
int: cost_y = 300;
int: cost_z = 1000;

% Variables
var 0..x_max: X;
var 0..y_max: Y;
var 0..z_max: Z;

var 0..(cost_x*x_max + cost_y*y_max + cost_z*z_max): total_cost;

% Constraints
constraint X + Y + Z <= budget_max;

constraint X >= Y + x_at_least_more_than_y;

constraint abs(Z - X) >= z_x_diff_min;
constraint abs(Z - X) <= z_x_diff_max;

constraint abs(Z - Y) >= z_y_diff_min;
constraint abs(Z - Y) <= z_y_diff_max;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;