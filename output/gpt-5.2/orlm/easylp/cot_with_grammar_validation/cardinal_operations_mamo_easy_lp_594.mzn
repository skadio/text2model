% Parameters
int: n = 4;
set of int: LOC = 1..n;

array[LOC] of int: cost = [2, 3, 4, 5];

int: cap12 = 500;
int: cap34 = 600;
int: min13 = 300;
int: min24 = 400;

array[LOC] of int: ub = [300, 200, 300, 400];

% Variables
array[LOC] of var 0..400: x; % fleet at each location (bounded broadly; tightened below)
var int: total_cost;

% Constraints
constraint forall(i in LOC) (x[i] <= ub[i]);

constraint x[1] + x[2] <= cap12;
constraint x[3] + x[4] <= cap34;

constraint x[1] + x[3] >= min13;
constraint x[2] + x[4] >= min24;

constraint total_cost = sum(i in LOC) (cost[i] * x[i]);

% Objective
solve minimize total_cost;