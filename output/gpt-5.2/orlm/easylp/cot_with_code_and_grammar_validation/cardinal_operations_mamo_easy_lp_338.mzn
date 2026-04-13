% Parameters
int: nProducts = 4;
set of int: P = 1..nProducts;

array[P] of int: cost = [5, 10, 20, 25];

% Constraint constants
int: max_x1_x2 = 100;
int: max_x3_x4_total = 200;
int: min_mix = 50;
int: max_diff = 70;

% Variables
array[P] of var int: x;

% Constraints
constraint forall(i in P)(x[i] >= 0);

% X1 + X2 <= 100
constraint x[1] + x[2] <= max_x1_x2;

% "For every 2 units of X3 produced, 3 units of X4 can be made" with a max limit 200:
% Model as ratio equality: 3*X3 = 2*X4, and total bounded: X3 + X4 <= 200
constraint 3 * x[3] = 2 * x[4];
constraint x[3] + x[4] <= max_x3_x4_total;

% X1 - 2*X2 + X3 >= 50
constraint x[1] - 2 * x[2] + x[3] >= min_mix;

% X1 - (X2 - X3) <= 70  <=>  X1 - X2 + X3 <= 70
constraint x[1] - x[2] + x[3] <= max_diff;

% Objective
solve minimize sum(i in P)(cost[i] * x[i]);