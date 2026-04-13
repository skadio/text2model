% Parameters
int: c1 = 500;
int: c2 = 400;
int: c3 = 300;
int: c4 = 200;

int: max_x1x2 = 1000;
int: min_2x2_plus_x3 = 800;

% Variable bounds (not explicitly given beyond integrality/non-negativity in the description)
int: UB = 100000; % safe upper bound to keep variables bounded

% Variables
var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;
var 0..UB: X4;

var 0..(c1*UB + c2*UB + c3*UB + c4*UB): total_cost;

% Constraints
constraint X1 + X2 <= max_x1x2;
constraint 2 * X2 + X3 >= min_2x2_plus_x3;

% X1 can't exceed half of X3  =>  2*X1 <= X3
constraint 2 * X1 <= X3;

% X4 requires at least 200 fewer than X1  =>  X4 <= X1 - 200
constraint X4 <= X1 - 200;

% X4 needs at least 150 fewer than X2  =>  X4 <= X2 - 150
constraint X4 <= X2 - 150;

% Define objective expression
constraint total_cost = c1 * X1 + c2 * X2 + c3 * X3 + c4 * X4;

% Objective
solve minimize total_cost;