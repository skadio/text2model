% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [150, 200, 300, 400];

int: cap12 = 1000;
int: cap34 = 500;

int: req12 = 1200;
int: req34 = 2500;

% Variables
array[P] of var int: x;          % allocations for X1..X4 (integer)
var int: total_cost;

% Constraints
constraint forall(i in P)(x[i] >= 0);

constraint x[1] + x[2] <= cap12;
constraint x[3] + x[4] <= cap34;

constraint 2*x[1] + 3*x[2] >= req12;
constraint 5*x[3] + 6*x[4] >= req34;

constraint total_cost = sum(i in P)(cost[i] * x[i]);

% Objective
solve minimize total_cost;