% Parameters
int: c1 = 500;
int: c2 = 600;
int: c3 = 800;
int: c4 = 700;

int: cap12 = 100;
int: cap34 = 50;

int: diffMin = 30;

% Specific bounds on each department's allocation (not provided explicitly);
% use non-negative integer allocations as the default explicit bound.
int: lb1 = 0; int: ub1 = 1000;
int: lb2 = 0; int: ub2 = 1000;
int: lb3 = 0; int: ub3 = 1000;
int: lb4 = 0; int: ub4 = 1000;

% Variables
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;
var lb4..ub4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x3 >= 2 * x1;
constraint 4 * x4 >= 3 * x2;

constraint (x3 + x4) - (x1 + x2) >= diffMin;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;