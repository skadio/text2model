include "globals.mzn";

% Parameters (provided in the .dzn file)
int: n_suppliers;
int: n_stores;
int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

% Decision variables
% For each store, choose a warehouse (supplier index in 1..n_suppliers)
array[1..n_stores] of var 1..n_suppliers: supply;

% For each supplier decide whether to open (1) or not (0)
array[1..n_suppliers] of var 0..1: open;

% Count how many stores are assigned to each supplier
array[1..n_suppliers] of var 0..n_stores: store_count;

% Lower and upper bounds for the number of assignments to each warehouse
array[1..n_suppliers] of int: lo = [0 | j in 1..n_suppliers];
array[1..n_suppliers] of int: up = capacity;

% Constraint: Each supplier gets assigned a number of stores between its lower and upper bounds.
constraint global_cardinality_low_up(supply, 1..n_suppliers, lo, up);

% Constraint: Count the number of stores assigned to each supplier.
constraint
  forall(j in 1..n_suppliers)(
    count(supply, j, store_count[j])
  );

% Linking constraint: A supplier is open if and only if it supplies at least one store.
constraint
  forall(j in 1..n_suppliers)(
    open[j] = if store_count[j] > 0 then 1 else 0 endif
  );

% Objective: Minimize total cost = (opening building cost for each opened supplier) + (supply cost for each store)
var int: total_cost = building_cost * sum(j in 1..n_suppliers)(open[j]) +
                         sum(i in 1..n_stores)( cost_matrix[i, supply[i]] );

solve minimize total_cost;

output [
  "Total Cost = ", show(total_cost), "\n",
  "Warehouse Open Decisions (0 = closed, 1 = open): ", show(open), "\n",
  "Store Assignments (store i is supplied by warehouse supply[i]): ", show(supply), "\n"
];