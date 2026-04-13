% Parameters (with values embedded)
int: n = 3;
set of int: PRODUCTS = 1..n;

array[PRODUCTS] of int: labor_per_unit = [17, 10, 2];
array[PRODUCTS] of int: inspect_per_unit = [8, 4, 2];
array[PRODUCTS] of int: profit_per_unit = [300, 200, 100];

int: labor_available = 1000;
int: inspect_available = 500;

array[PRODUCTS] of int: demand_max = [50, 80, 150];

% Variables
array[PRODUCTS] of var 0..150: x; % production quantities (bounded by max possible demand)
var int: total_profit;

% Constraints
constraint forall(i in PRODUCTS) (x[i] <= demand_max[i]);

constraint sum(i in PRODUCTS) (labor_per_unit[i] * x[i]) <= labor_available;
constraint sum(i in PRODUCTS) (inspect_per_unit[i] * x[i]) <= inspect_available;

constraint total_profit = sum(i in PRODUCTS) (profit_per_unit[i] * x[i]);

% Objective
solve maximize total_profit;