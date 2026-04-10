% Parameters
int: c1 = 5;
int: c2 = 10;
int: c3 = 20;
int: c4 = 25;

int: max_x1x2 = 100;
int: max_x3x4 = 200;

int: min_expr = 50;
int: max_diff = 70;

% (No explicit per-variable bounds were provided beyond non-negativity)
int: UB = 1000; % safe upper bound to keep variables bounded

% Variables
var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;
var 0..UB: X4;

var int: total_cost;

% Constraints
constraint X1 + X2 <= max_x1x2;

constraint 3 * X3 + 2 * X4 <= max_x3x4;

constraint X1 - 2 * X2 + X3 >= min_expr;

constraint X1 - X2 - X3 <= max_diff;

constraint total_cost = c1 * X1 + c2 * X2 + c3 * X3 + c4 * X4;

% Objective
solve minimize total_cost;