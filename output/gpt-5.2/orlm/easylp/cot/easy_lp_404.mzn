% Parameters (with values embedded)
int: n = 4;
set of int: C = 1..n;

array[C] of int: cost = [4, 3, 5, 7];

array[C] of int: lb = [0, 0, 0, 0];
array[C] of int: ub = [700, 600, 400, 500];

int: cap12 = 1000;
int: cap34 = 800;
int: dem13 = 500;
int: dem24 = 600;

% Variables
array[C] of var int: x;
var int: total_cost;

% Constraints
constraint forall(i in C) (lb[i] <= x[i] /\ x[i] <= ub[i]);

constraint x[1] + x[2] <= cap12;
constraint x[3] + x[4] <= cap34;

constraint x[1] + x[3] >= dem13;
constraint x[2] + x[4] >= dem24;

constraint total_cost = sum(i in C)(cost[i] * x[i]);

% Objective
solve minimize total_cost;