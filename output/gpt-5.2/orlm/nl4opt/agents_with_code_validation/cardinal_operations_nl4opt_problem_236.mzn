% Store types: 1 = dine-in, 2 = food-truck
int: n_store_types = 2;
set of int: STORE = 1..n_store_types;

% Production capacity (sandwiches/day) per store type
array[STORE] of int: sandwiches_per_store = [100, 50];

% Employees required per store type
array[STORE] of int: employees_per_store = [8, 3];

% Requirements and limits
int: min_sandwiches = 500;
int: max_employees = 35;

% Upper bounds derived from limits (safe bounds for decision vars)
array[STORE] of int: max_stores_by_employees =
  [ max_employees div employees_per_store[t] | t in STORE ];

array[STORE] of int: max_stores_by_sandwiches =
  [ (min_sandwiches + sandwiches_per_store[t] - 1) div sandwiches_per_store[t] | t in STORE ];

array[STORE] of int: max_stores =
  [ max(max_stores_by_employees[t], max_stores_by_sandwiches[t]) | t in STORE ];

% Variables
array[STORE] of var int: n_open;
constraint forall(t in STORE)(n_open[t] >= 0 /\ n_open[t] <= max_stores[t]);

var 0..sum(t in STORE)(max_stores[t]): total_stores;

% Constraints
constraint total_stores = sum(t in STORE)(n_open[t]);

constraint sum(t in STORE)(sandwiches_per_store[t] * n_open[t]) >= min_sandwiches;

constraint sum(t in STORE)(employees_per_store[t] * n_open[t]) <= max_employees;

% Objective
solve minimize total_stores;

output [
  "dine_in=", show(n_open[1]), "\n",
  "food_truck=", show(n_open[2]), "\n",
  "total_stores=", show(total_stores), "\n"
];