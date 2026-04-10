% Parameters
int: n = 4;
set of int: CROPS = 1..n;

array[CROPS] of int: cost = [5, 3, 7, 6];
array[CROPS] of int: max_acres = [100, 200, 150, 120];

% Variables
array[CROPS] of var 0..200: x;

var int: total_cost;

% Constraints
constraint forall(i in CROPS) (x[i] <= max_acres[i]);

% Fertilizer: 2*x1 + 3*x2 <= 50
constraint 2*x[1] + 3*x[2] <= 50;

% Water: 4*x1 + x3 <= 40
constraint 4*x[1] + x[3] <= 40;

% Soil: 5*x4 >= x2 + 10
constraint 5*x[4] >= x[2] + 10;

% Ecological balance: (x1 + x2) - (x3 + x4) = 0
constraint (x[1] + x[2]) - (x[3] + x[4]) = 0;

% Cost definition
constraint total_cost = sum(i in CROPS)(cost[i] * x[i]);

% Objective
solve minimize total_cost;