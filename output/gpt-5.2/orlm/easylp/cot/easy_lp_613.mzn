% Parameters (with values embedded)
int: n = 4;
set of int: CROPS = 1..n;

% Cost per acre for crops x1..x4
array[CROPS] of int: cost = [5, 3, 7, 6];

% Maximum acres for crops x1..x4
array[CROPS] of int: max_acres = [100, 200, 150, 120];

% Variables
array[CROPS] of var int: x; % acres planted for each crop (whole numbers)

% Constraints
constraint forall(i in CROPS) (
  0 <= x[i] /\ x[i] <= max_acres[i]
);

% 2*x1 + 3*x2 <= 50  (fertilizer availability)
constraint 2*x[1] + 3*x[2] <= 50;

% 4*x1 + x3 <= 40 (water supply)
constraint 4*x[1] + x[3] <= 40;

% 5*x4 >= x2 + 10 (soil requirement)
constraint 5*x[4] >= x[2] + 10;

% (x1 + x2) - (x3 + x4) = 0 (ecological balance)
constraint x[1] + x[2] = x[3] + x[4];

% Objective
var int: total_cost = sum(i in CROPS)(cost[i] * x[i]);
solve minimize total_cost;