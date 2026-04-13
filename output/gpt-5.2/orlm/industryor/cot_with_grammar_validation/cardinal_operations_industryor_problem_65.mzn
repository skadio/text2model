% Parameters
int: n = 3;
set of int: P = 1..n;

array[P] of int: labor_per_unit = [17, 10, 2];
array[P] of int: inspect_per_unit = [8, 4, 2];
array[P] of int: profit_per_unit = [300, 200, 100];

int: labor_avail = 1000;
int: inspect_avail = 500;

array[P] of int: demand_max = [50, 80, 150];

% Variables
array[P] of var 0..150: x;

var int: total_profit;

% Constraints
constraint forall(i in P) (x[i] <= demand_max[i]);

constraint sum(i in P)(labor_per_unit[i] * x[i]) <= labor_avail;
constraint sum(i in P)(inspect_per_unit[i] * x[i]) <= inspect_avail;

constraint total_profit = sum(i in P)(profit_per_unit[i] * x[i]);

% Objective
solve maximize total_profit;