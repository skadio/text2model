% Parameters
int: c1 = 100;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

int: max_x1_x2 = 30;
int: min_2x1_plus_x3 = 40;
int: x4_minus_x2 = 20;
int: min_x1_plus_half_x3 = 10;

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

var int: total_cost;

% Constraints
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

constraint x1 + x2 <= max_x1_x2;
constraint 2 * x1 + x3 >= min_2x1_plus_x3;
constraint x4 - x2 = x4_minus_x2;

% enforce (x1 + x3/2 >= 10) without fractions: 2*x1 + x3 >= 20
constraint 2 * x1 + x3 >= 2 * min_x1_plus_half_x3;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;