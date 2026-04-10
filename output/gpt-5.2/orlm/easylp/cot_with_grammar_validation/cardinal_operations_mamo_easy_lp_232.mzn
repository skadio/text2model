% Parameters
int: budget = 1000;
int: a_x = 4;
int: a_y = 5;
int: target_xy = 3000;
int: b_z = 1;
int: b_y = -3;
int: min_zy = -500;

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 1;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(cost_x*budget + cost_y*budget + cost_z*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint a_x * X + a_y * Y >= target_xy;

constraint b_z * Z + b_y * Y >= min_zy;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;