% Parameters
int: budget = 1000;
int: rhs1 = 10;
int: rhs2 = 30;

int: cx = 5;
int: cy = 6;
int: cz = 7;

int: x_max = 500;
int: y_max = 400;
int: z_min = 50;

% Variables
var 0..x_max: X;
var 0..y_max: Y;
var z_min..budget: Z;

var 0..(cx*x_max + cy*y_max + cz*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;
constraint 3*X + 2*Y - Z >= rhs1;
constraint Z - Y >= rhs2;

constraint total_cost = cx*X + cy*Y + cz*Z;

% Objective
solve minimize total_cost;