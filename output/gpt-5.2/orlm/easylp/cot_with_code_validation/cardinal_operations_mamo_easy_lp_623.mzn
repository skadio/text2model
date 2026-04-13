% Parameters
int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

int: max_x1x2 = 1000;

int: min_2x2_plus_x3 = 500;

int: max_half_x3_minus_x1 = 200;

int: min_x4_minus_x2 = -400;

% 0.8*x4 - x3 <= -300  ->  (8/10)*x4 - x3 <= -300  ->  8*x4 - 10*x3 <= -3000
int: max_8x4_minus_10x3 = -3000;

% Variable bounds (nonnegative integer allocations; explicit upper bound to keep search bounded)
int: UB = 10000;

% Variables
var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;
var 0..UB: X4;

var 0..(c1*UB + c2*UB + c3*UB + c4*UB): total_cost;

% Constraints
constraint X1 + X2 <= max_x1x2;

constraint 2*X2 + X3 >= min_2x2_plus_x3;

% (1/2)*X3 - X1 <= 200  ->  X3 - 2*X1 <= 400
constraint X3 - 2*X1 <= 400;

constraint X4 - X2 >= min_x4_minus_x2;

constraint 8*X4 - 10*X3 <= max_8x4_minus_10x3;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;