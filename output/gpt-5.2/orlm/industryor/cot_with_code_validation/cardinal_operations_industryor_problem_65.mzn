% Parameters
int: n = 3;
set of int: P = 1..n;

array[P] of int: labor_req = [17, 10, 2];
array[P] of int: inspect_req = [8, 4, 2];
array[P] of int: profit = [300, 200, 100];

int: labor_avail = 1000;
int: inspect_avail = 500;

array[P] of int: demand_max = [50, 80, 150];

% Variables
array[P] of var 0..150: x;

% Constraints
constraint forall(i in P) (x[i] <= demand_max[i]);

constraint sum(i in P) (labor_req[i] * x[i]) <= labor_avail;
constraint sum(i in P) (inspect_req[i] * x[i]) <= inspect_avail;

% Objective
solve maximize sum(i in P) (profit[i] * x[i]);