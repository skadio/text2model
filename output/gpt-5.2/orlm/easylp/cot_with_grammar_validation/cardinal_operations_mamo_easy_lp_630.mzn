% Parameters
int: c1 = 500;
int: c2 = 600;
int: c3 = 800;
int: c4 = 700;

int: cap12 = 100;
int: cap34 = 50;

int: diff34_12 = 30;

% Variable bounds (integer allocations)
int: x1_lb = 0; int: x1_ub = 100;
int: x2_lb = 0; int: x2_ub = 100;
int: x3_lb = 0; int: x3_ub = 50;
int: x4_lb = 0; int: x4_ub = 50;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x3 >= 2 * x1;
constraint 4 * x4 >= 3 * x2;

constraint (x3 + x4) - (x1 + x2) >= diff34_12;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;