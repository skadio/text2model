% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [500, 300, 700, 600];

int: maxX1 = 50;
int: maxX2 = 60;
int: maxX3 = 40;
int: maxX4 = 30;

% Variables
var 0..maxX1: X1;
var 0..maxX2: X2;
var 0..maxX3: X3;
var 0..maxX4: X4;

% Constraints
constraint X1 + X2 <= 100;
constraint 2*X3 + X4 <= 120;
constraint X1 + X3 >= 60;
constraint X2 + X4 >= 80;

% Objective
var int: total_cost = cost[1]*X1 + cost[2]*X2 + cost[3]*X3 + cost[4]*X4;
solve minimize total_cost;