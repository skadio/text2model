% Parameters
int: N = 4;
set of int: R = 1..N;

array[R] of int: cost = [10, 20, 30, 40];

int: cap12 = 1000;
int: cap34 = 2000;

int: diff31 = 500;  % x3 >= x1 + 500
int: diff42 = 300;  % x4 >= x2 + 300

array[R] of int: ub = [700, 800, 900, 1000];

% Variables
array[R] of var 0..1000: x;
var int: total_cost;

% Constraints
constraint forall(r in R) (x[r] <= ub[r]);

constraint x[1] + x[2] <= cap12;
constraint x[3] + x[4] <= cap34;

constraint x[3] >= x[1] + diff31;
constraint x[4] >= x[2] + diff42;

constraint total_cost = sum(r in R)(cost[r] * x[r]);

% Objective
solve minimize total_cost;