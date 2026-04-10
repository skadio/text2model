% Parameters
int: c1 = 500;
int: c2 = 400;
int: c3 = 300;
int: c4 = 200;

int: max_x1x2 = 1000;
int: min_2x2_plus_x3 = 800;

% Variables
var 0..1000: X1;
var 0..1000: X2;
var 0..1000: X3;
var 0..1000: X4;

var 0..1000000000: total_cost;

% Constraints
constraint X1 + X2 <= max_x1x2;
constraint 2 * X2 + X3 >= min_2x2_plus_x3;
constraint 2 * X1 <= X3;

constraint X4 <= X1 - 200;
constraint X4 <= X2 - 150;

constraint total_cost = c1 * X1 + c2 * X2 + c3 * X3 + c4 * X4;

% Objective
solve minimize total_cost;