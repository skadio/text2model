% Parameters (with values embedded)
int: rev1 = 4;
int: rev2 = 3;
int: rev3 = 5;
int: rev4 = 6;

int: cap12 = 1000;
int: cap34 = 800;

% Contract requirements as exact integer inequalities (clearing denominators)
% (1/2)x1 + (1/4)x2 >= 300  <=>  2*x1 + x2 >= 1200
% (3/4)x3 + (3/5)x4 >= 250  <=>  15*x3 + 12*x4 >= 5000
int: req1_rhs = 1200;
int: req2_rhs = 5000;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 2*x1 + x2 >= req1_rhs;
constraint 15*x3 + 12*x4 >= req2_rhs;

% Objective
% "Minimum total cost": using the given per-unit rates as costs.
var 0..(rev1*cap12 + rev2*cap12 + rev3*cap34 + rev4*cap34): total_cost =
    rev1*x1 + rev2*x2 + rev3*x3 + rev4*x4;

solve minimize total_cost;