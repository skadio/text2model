include "globals.mzn";

/* Constants supplied by the .dzn file */
int: num_parts;
int: num_stores;
array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

/* Decision variables */
array[1..num_parts] of var 1..num_stores: assignment;      % part → store
array[1..num_stores] of var bool: used;                    % is store used?

/* Linking constraint: a store is used iff at least one part is bought there */
constraint
  forall(j in 1..num_stores) (
    used[j] = (sum(i in 1..num_parts) (assignment[i] == j) >= 1)
  );

/* Cost calculation */
var float: total_cost;
constraint
  total_cost = sum(i in 1..num_parts) product_stores[i, assignment[i]]
            + sum(j in 1..num_stores) bool2int(used[j]) * store_delivery_costs[j];

/* Objective */
solve minimize total_cost;

/* Output */
output [
  "Assignments (part → store): ", show(assignment), "\n",
  "Total cost: ", show(total_cost), "\n"
];