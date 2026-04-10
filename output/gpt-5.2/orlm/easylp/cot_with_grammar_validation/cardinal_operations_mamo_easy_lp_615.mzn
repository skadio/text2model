% Parameters
int: cost1 = 500;
int: cost2 = 400;
int: cost3 = 300;
int: cost4 = 200;

int: limit_x1_x2 = 1000;
int: min_2x2_plus_x3 = 800;

% Variables
var 0..1000: X1;
var 0..1000: X2;
var 0..1000: X3;
var 0..1000: X4;

var 0..1000000000: total_cost;

% Constraints
constraint X1 + X2 <= limit_x1_x2;
constraint 2 * X2 + X3 >= min_2x2_plus_x3;

% X1 can't exceed half of X3  =>  2*X1 <= X3
constraint 2 * X1 <= X3;

% X4 requires at least 200 fewer resources than X1  =>  X4 <= X1 - 200
constraint X4 <= X1 - 200;

% X4 requires at least 150 fewer resources than X2  =>  X4 <= X2 - 150
constraint X4 <= X2 - 150;

% Define objective expression
constraint total_cost = cost1 * X1 + cost2 * X2 + cost3 * X3 + cost4 * X4;

% Objective
solve minimize total_cost;