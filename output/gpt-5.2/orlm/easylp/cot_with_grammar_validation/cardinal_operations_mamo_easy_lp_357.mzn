% Parameters
int: max_x1x2 = 500;
int: max_x3x4 = 300;
int: min_x1x3 = 200;
int: min_x2x4 = 100;

int: ub_x1 = 250;
int: ub_x2 = 250;
int: ub_x3 = 150;
int: ub_x4 = 150;

% Costs in cents to keep integrality (1.5 -> 150 cents, etc.)
int: c1 = 150;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

var 0..(c1*ub_x1 + c2*ub_x2 + c3*ub_x3 + c4*ub_x4): total_cost_cents;

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint x3 + x4 <= max_x3x4;
constraint x1 + x3 >= min_x1x3;
constraint x2 + x4 >= min_x2x4;

constraint total_cost_cents = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost_cents;