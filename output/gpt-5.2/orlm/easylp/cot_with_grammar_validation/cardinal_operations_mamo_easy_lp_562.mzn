% Parameters
int: budget = 1000;
int: min_2x_plus_y = 400;
int: min_y_plus_z = 500;

int: benefit_x = 5;
int: benefit_y = 3;
int: benefit_z = 1;

int: x_lb = 0; int: x_ub = 600;
int: y_lb = 0; int: y_ub = 400;
int: z_lb = 0; int: z_ub = 300;

% Variables
var x_lb..x_ub: X;
var y_lb..y_ub: Y;
var z_lb..z_ub: Z;

var 0..budget: total_cost;

% Constraints
constraint total_cost = X + Y + Z;

constraint X + Y + Z <= budget;
constraint 2 * X + Y >= min_2x_plus_y;
constraint Y + Z >= min_y_plus_z;

% Objective
solve minimize total_cost;