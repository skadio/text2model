% Parameters
int: n = 4;
set of int: DEST = 1..n;

array[DEST] of int: cost = [200, 150, 100, 50];

int: ub12 = 300;
int: ub34 = 200;
int: lb13 = 150;
int: lb24 = 150;

% Variables
array[DEST] of var int: x;

var int: total_cost;

% Constraints
constraint forall(i in DEST)(x[i] >= 0);

constraint x[1] + x[2] <= ub12;
constraint x[3] + x[4] <= ub34;

constraint x[1] + x[3] >= lb13;
constraint x[2] + x[4] >= lb24;

constraint total_cost = sum(i in DEST)(cost[i] * x[i]);

% Objective
solve minimize total_cost;